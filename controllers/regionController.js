const pool = require('../config/db');

// 1. GET REGIONS WITH STATS
exports.getRegions = async (req, res) => {
    try {
        const query = `
            SELECT 
                r.*,
                COALESCE(o.office_count, 0)::integer as office_count,
                COALESCE(rec.record_count, 0)::integer as record_count,
                COALESCE(rec.total_storage, 0)::bigint as total_storage,
                COALESCE(u.user_count, 0)::integer as user_count
            FROM regions r
            LEFT JOIN (
                SELECT region_id::integer, COUNT(*) as office_count 
                FROM offices WHERE status = 'Active' 
                GROUP BY region_id
            ) o ON r.id = o.region_id
            LEFT JOIN (
                SELECT region_id::integer, COUNT(*) as record_count, SUM(file_size) as total_storage
                FROM records WHERE status = 'Active' 
                GROUP BY region_id
            ) rec ON r.id = rec.region_id
            LEFT JOIN (
                SELECT region_id::integer, COUNT(*) as user_count 
                FROM users WHERE status = 'Active' 
                GROUP BY region_id
            ) u ON r.id = u.region_id
            ORDER BY r.id ASC
        `;
        const { rows } = await pool.query(query);

        // Debug: Log the first region's stats
        if (rows.length > 0) {
            console.log('[getRegions] Sample region stats:', {
                name: rows[0].name,
                office_count: rows[0].office_count,
                record_count: rows[0].record_count,
                user_count: rows[0].user_count
            });
        }

        res.json(rows);
    } catch (err) {
        console.error("Get Regions Error:", err);
        res.status(500).json({ message: "Server Error" });
    }
};

// 2. CREATE REGION (Updated to accept Address & Status)
exports.createRegion = async (req, res) => {
    try {
        console.log("--- Creating Region ---");
        const { name, code, address, status } = req.body;
        console.log("Data Received:", req.body);

        if (!name || !code) return res.status(400).json({ message: "Name and Code are required" });

        // Insert all 4 fields
        const result = await pool.query(
            "INSERT INTO regions (name, code, address, status) VALUES ($1, $2, $3, $4) RETURNING *",
            [name, code, address || '', status || 'Active']
        );

        console.log("✅ Region Saved:", result.rows[0]);
        res.json({ message: "Region Registered", region: result.rows[0] });

    } catch (err) {
        console.error("❌ Add Region Error:", err.message);
        res.status(500).json({ message: "Server Error: " + err.message });
    }
};

// 3. UPDATE REGION (Updated to edit Address & Status)
exports.updateRegion = async (req, res) => {
    try {
        const { id } = req.params;
        const { name, code, address, status } = req.body;

        await pool.query(
            "UPDATE regions SET name = $1, code = $2, address = $3, status = $4 WHERE id = $5",
            [name, code, address, status, id]
        );
        res.json({ message: "Region Updated" });
    } catch (err) {
        console.error("Update Region Error:", err.message);
        res.status(500).json({ message: "Update Failed" });
    }
};

// 4. DELETE REGION
exports.deleteRegion = async (req, res) => {
    try {
        const { id } = req.params;
        await pool.query("DELETE FROM regions WHERE id = $1", [id]);
        res.json({ message: "Region Deleted" });
    } catch (err) {
        res.status(500).json({ message: "Delete Failed" });
    }
};