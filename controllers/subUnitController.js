const pool = require('../config/db');

// GET SUB-UNITS (Now fetches from offices table where parent_id is set)
exports.getSubUnits = async (req, res) => {
    try {
        const { office_id } = req.query;

        // If no office_id provided, maybe return all sub-units? 
        // Or return empty to be safe? 
        // Existing logic returned all if no filter. Let's keep it but it's likely large.

        let query = "SELECT * FROM offices WHERE parent_id IS NOT NULL AND status = 'Active'";
        const params = [];

        if (office_id) {
            query = "SELECT * FROM offices WHERE parent_id = $1 AND status = 'Active'";
            params.push(office_id);
        }

        query += " ORDER BY name ASC";
        const result = await pool.query(query, params);
        res.json(result.rows);
    } catch (err) {
        console.error("Get SubUnits Error:", err.message);
        res.status(500).json({ message: "Server Error" });
    }
};

// CREATE SUB-UNIT (Creates an office with parent_id)
exports.createSubUnit = async (req, res) => {
    try {
        const { office_id, name, description } = req.body;

        if (!office_id || !name) {
            return res.status(400).json({ message: "Parent Office and Name are required." });
        }

        // 1. Get Parent Info (to inherit region)
        const parentCheck = await pool.query("SELECT region_id FROM offices WHERE office_id = $1", [office_id]);
        if (parentCheck.rows.length === 0) {
            return res.status(404).json({ message: "Parent office not found" });
        }
        const region_id = parentCheck.rows[0].region_id;

        // 2. Generate a simple code if not provided (first 3-5 chars of name uppercase)
        // This is a fallback since offices table has 'code'.
        const code = name.replace(/[^a-zA-Z]/g, '').substring(0, 5).toUpperCase();

        const result = await pool.query(
            `INSERT INTO offices (parent_id, region_id, name, description, code, status) 
             VALUES ($1, $2, $3, $4, $5, 'Active') 
             RETURNING *`,
            [office_id, region_id, name, description, code]
        );

        res.json(result.rows[0]);
    } catch (err) {
        console.error("Create SubUnit Error:", err.message);
        if (err.code === '23505') { // Unique violation
            // This might happen if code constraint is unique, or name/parent combo if we had that constraint (we don't on offices usually?)
            // Offices usually has unique code.
            return res.status(400).json({ message: "Sub-unit with this code/name already exists." });
        }
        res.status(500).json({ message: "Server Error" });
    }
};
