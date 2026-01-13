const pool = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { logAudit } = require('../utils/auditLogger');

const JWT_SECRET = process.env.JWT_SECRET || "dost_secret_key_2025";

exports.login = async (req, res) => {
    try {
        const { username, password } = req.body;
        
        console.log(`[LOGIN ATTEMPT] Username: ${username} | Password: ${password}`);

        // 1. Check if username/password were actually sent
        if (!username || !password) {
            return res.status(400).json({ message: "Debug: Username or Password missing from request body." });
        }

        // 2. Check if user exists in DB
        const result = await pool.query("SELECT * FROM users WHERE username = $1", [username]);
        
        if (result.rows.length === 0) {
            // DEBUG MODE: Telling you the user doesn't exist
            console.log(`[LOGIN FAILURE] User '${username}' not found in database.`);
            return res.status(401).json({ message: `Debug: User '${username}' does not exist in the database.` });
        }

        const user = result.rows[0];
        console.log(`[LOGIN DEBUG] Found User: ${user.username} (ID: ${user.user_id})`);
        console.log(`[LOGIN DEBUG] Stored Password Hash: ${user.password}`);

        // 3. PASSWORD CHECK (Dual Mode)
        const isHashMatch = await bcrypt.compare(password, user.password || "");
        const isPlainMatch = (password === user.password); // Checks for "password123"

        if (!isHashMatch && !isPlainMatch) {
            console.log(`[LOGIN FAILURE] Password mismatch.`);
            return res.status(401).json({ message: "Debug: Incorrect Password. (Hash failed & Plain text failed)" });
        }

        // 4. Check Status
        if (user.status !== 'Active' && user.status !== 'ACTIVE') {
            return res.status(403).json({ message: "Account is suspended." });
        }

        // 5. Generate Token
        const token = jwt.sign(
            { 
                user_id: user.user_id, 
                role: user.role, 
                region_id: user.region_id, 
                username: user.username 
            }, 
            JWT_SECRET, 
            { expiresIn: '24h' }
        );

        // 6. Log & Respond
        req.user = { id: user.user_id, username: user.username, role: user.role, region_id: user.region_id };
        await logAudit(req, 'LOGIN_SUCCESS', `User ${user.username} logged in.`);

        res.json({
            message: "Login Successful",
            token,
            user: {
                id: user.user_id,
                username: user.username,
                role: user.role,
                region_id: user.region_id,
                office: user.office
            }
        });

    } catch (err) {
        console.error("Login System Error:", err);
        res.status(500).json({ message: "Server Error: " + err.message });
    }
};

exports.getMe = async (req, res) => {
    try {
        const result = await pool.query("SELECT user_id, username, role, region_id, office, status FROM users WHERE user_id = $1", [req.user.user_id]);
        if (result.rows.length === 0) return res.status(404).json({ message: "User not found" });
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ message: "Server Error" });
    }
};