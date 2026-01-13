const pool = require('../config/db');
const { logAudit } = require('../utils/auditLogger');

// 1. GET SETTINGS
exports.getSettings = async (req, res) => {
    try {
        const result = await pool.query("SELECT * FROM system_settings WHERE id = 1");
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ message: "Error loading settings" });
    }
};

// 2. UPDATE SETTINGS
exports.updateSettings = async (req, res) => {
    try {
        const { system_name, org_name, welcome_msg, primary_color, secondary_color } = req.body;
        
        // Handle File Uploads
        const logo_url = req.files['logo'] ? `/uploads/${req.files['logo'][0].filename}` : undefined;
        const login_bg_url = req.files['bg'] ? `/uploads/${req.files['bg'][0].filename}` : undefined;

        // Build Dynamic Query
        let query = `UPDATE system_settings SET 
            system_name = COALESCE($1, system_name),
            org_name = COALESCE($2, org_name),
            welcome_msg = COALESCE($3, welcome_msg),
            primary_color = COALESCE($4, primary_color),
            secondary_color = COALESCE($5, secondary_color),
            updated_at = NOW()`;

        const params = [system_name, org_name, welcome_msg, primary_color, secondary_color];
        let counter = 6;

        if (logo_url) { query += `, logo_url = $${counter++}`; params.push(logo_url); }
        if (login_bg_url) { query += `, login_bg_url = $${counter++}`; params.push(login_bg_url); }

        query += ` WHERE id = 1 RETURNING *`;

        const result = await pool.query(query, params);
        
        await logAudit(req, 'UPDATE_BRANDING', `Updated system appearance.`);
        res.json({ message: "Settings Saved", settings: result.rows[0] });

    } catch (err) {
        console.error("Settings Update Error:", err);
        res.status(500).json({ message: "Update Failed" });
    }
};