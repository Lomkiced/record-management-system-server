const pool = require('../config/db');
const { logAudit } = require('../utils/auditLogger');

// 1. GET SETTINGS
exports.getSettings = async (req, res) => {
    try {
        // Strict fetch: Only ID 1
        const result = await pool.query("SELECT * FROM system_settings WHERE id = 1");
        
        if (result.rows.length === 0) {
            // Self-Heal: If row is missing, recreate it instantly
            await pool.query("INSERT INTO system_settings (id) VALUES (1) ON CONFLICT DO NOTHING");
            return res.json({ 
                system_name: 'DOST-RMS', 
                primary_color: '#4f46e5', 
                secondary_color: '#0f172a' 
            });
        }

        // Cache-Control: Force Browser to Re-Check every time
        res.set('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');
        res.set('Pragma', 'no-cache');
        res.set('Expires', '0');

        res.json(result.rows[0]);
    } catch (err) {
        console.error("Settings Load Error:", err);
        res.status(500).json({ message: "System Error" });
    }
};

// 2. UPDATE SETTINGS
exports.updateSettings = async (req, res) => {
    try {
        console.log("📝 UPDATING BRANDING...");
        console.log("📦 Data:", req.body);
        console.log("📂 Files:", req.files ? Object.keys(req.files) : "None");

        const { system_name, org_name, welcome_msg, primary_color, secondary_color } = req.body;
        const files = req.files || {};
        
        const logo_url = files['logo'] ? `/uploads/${files['logo'][0].filename}` : undefined;
        const login_bg_url = files['bg'] ? `/uploads/${files['bg'][0].filename}` : undefined;

        // Build Query dynamically
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

        query += ` WHERE id = 1 RETURNING *`; // <--- Ensure we target ID 1

        const result = await pool.query(query, params);

        if (result.rows.length === 0) {
            console.error("❌ UPDATE FAILED: Row ID 1 not found.");
            return res.status(404).json({ message: "Settings database corrupted. Run repair script." });
        }

        console.log("✅ UPDATE SUCCESS:", result.rows[0]);

        if (req.user) await logAudit(req, 'UPDATE_BRANDING', `System branding updated.`);
        
        res.json({ message: "Settings Saved", settings: result.rows[0] });

    } catch (err) {
        console.error("❌ SERVER UPDATE ERROR:", err);
        res.status(500).json({ message: "Update Failed: " + err.message });
    }
};