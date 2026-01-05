const pool = require('../config/db');
const bcrypt = require('bcryptjs');
const { logAudit } = require('../utils/auditLogger');

// --- HELPER: ID PARSING ---
const parseId = (id) => {
    if (id === undefined || id === null || id === '') return null;
    const parsed = parseInt(id, 10);
    return isNaN(parsed) ? null : parsed;
};

// --- HELPER: SCOPE ENFORCER ---
const getTargetRegion = (req, requestedRegionId) => {
    // Super Admins can assign users to ANY region
    if (req.user.role === 'SUPER_ADMIN') {
        return parseId(requestedRegionId);
    }
    // Regional Admins are FORCED to their own region
    return parseId(req.user.region_id);
};

// 1. GET USERS (Scoped Security)
exports.getUsers = async (req, res) => {
    try {
        let query = `
            SELECT u.user_id, u.username, u.name, u.role, u.region_id, u.office, u.status, u.created_at,
                   r.name as region_name 
            FROM users u
            LEFT JOIN regions r ON u.region_id = r.id 
            WHERE 1=1
        `;
        let params = [];
        let counter = 1;

        // SECURITY: Regional Admins see EVERYONE in their Region (Admins & Staff)
        if (req.user.role === 'ADMIN' || req.user.role === 'REGIONAL_ADMIN') {
            query += ` AND u.region_id = $${counter++}`;
            params.push(req.user.region_id);
            // Hide Super Admins from Regional view to avoid confusion
            query += ` AND u.role != 'SUPER_ADMIN'`;
        }
        // SECURITY: Staff see nobody
        else if (req.user.role === 'STAFF') {
             return res.status(403).json({ message: "Access Denied" });
        }

        query += " ORDER BY u.role ASC, u.name ASC"; // Admins listed first
        
        const result = await pool.query(query, params);
        res.json(result.rows);

    } catch (err) {
        console.error("Get Users Error:", err.message);
        res.status(500).json({ message: "Server Error" });
    }
};

// 2. CREATE USER (Auto-Link & Audit)
exports.createUser = async (req, res) => {
    try {
        const { username, password, name, role, office, region_id } = req.body;
        
        if (!username || !password || !name) {
            return res.status(400).json({ message: "Missing required fields." });
        }

        // 1. Determine Scope
        const targetRegion = getTargetRegion(req, region_id);

        // 2. Security Check: Regional Admin Restrictions
        if (req.user.role === 'ADMIN' || req.user.role === 'REGIONAL_ADMIN') {
            // Can only create ADMIN (Co-Admin) or STAFF
            if (role === 'SUPER_ADMIN') {
                return res.status(403).json({ message: "You cannot create Super Admins." });
            }
        }

        // 3. Check Duplicates
        const check = await pool.query("SELECT username FROM users WHERE username = $1", [username]);
        if (check.rows.length > 0) return res.status(400).json({ message: "Username already exists" });

        // 4. Hash Password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // 5. Insert
        const result = await pool.query(
            `INSERT INTO users (username, password, name, role, region_id, office, status) 
             VALUES ($1, $2, $3, $4, $5, $6, 'Active') 
             RETURNING user_id, username, name, role, region_id`,
            [username, hashedPassword, name, role, targetRegion, office]
        );

        // 6. Log Event
        await logAudit(req, 'ADD_USER', `Onboarded ${role} "${username}" to Region ${targetRegion}`);

        res.json({ message: "User Created Successfully", user: result.rows[0] });

    } catch (err) {
        console.error("Create User Error:", err.message);
        res.status(500).json({ message: "Server Error" });
    }
};

// 3. UPDATE USER
exports.updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { name, office, status, password, role } = req.body;

        // Security: Regional Admin can only touch their own region
        if (req.user.role === 'ADMIN' || req.user.role === 'REGIONAL_ADMIN') {
            const verify = await pool.query("SELECT region_id FROM users WHERE user_id = $1", [id]);
            if (verify.rows.length === 0 || verify.rows[0].region_id !== req.user.region_id) {
                return res.status(403).json({ message: "Unauthorized access." });
            }
        }

        let query = "UPDATE users SET name = $1, office = $2, status = $3";
        let params = [name, office, status];
        let counter = 4;

        // Allow Role Change
        if (role) {
             query += `, role = $${counter++}`;
             params.push(role);
        }

        if (password && password.trim() !== "") {
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash(password, salt);
            query += `, password = $${counter++}`;
            params.push(hashedPassword);
        }

        query += ` WHERE user_id = $${counter}`;
        params.push(id);

        await pool.query(query, params);
        await logAudit(req, 'UPDATE_USER', `Updated User ID: ${id}`);
        
        res.json({ message: "User Updated" });

    } catch (err) {
        res.status(500).json({ message: "Server Error" });
    }
};

// 4. DELETE USER
exports.deleteUser = async (req, res) => {
    try {
        const { id } = req.params;

        if (req.user.role === 'ADMIN' || req.user.role === 'REGIONAL_ADMIN') {
            const verify = await pool.query("SELECT region_id FROM users WHERE user_id = $1", [id]);
            if (verify.rows.length === 0 || verify.rows[0].region_id !== req.user.region_id) {
                return res.status(403).json({ message: "Unauthorized." });
            }
            if (parseInt(id) === req.user.id) {
                 return res.status(400).json({ message: "You cannot delete your own account." });
            }
        }

        await pool.query("DELETE FROM users WHERE user_id = $1", [id]);
        await logAudit(req, 'DELETE_USER', `Deleted User ID: ${id}`);
        res.json({ message: "User Deleted" });

    } catch (err) {
        res.status(500).json({ message: "Server Error" });
    }
};