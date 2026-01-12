const pool = require('../config/db');

/**
 * * FILTERED LOGS: Returns filtered logs based on user role level and region
 */
exports.filteredLogs = async (req, res) => {
    try {
        const { role, region_id } = req.user;
        const { region_filter } = req.query; // Allow Super Admin to filter via query param

        if (role === 'STAFF') {
            return res.status(403).json({ message: "Access Denied." });
        }

        // JOIN with regions table to get the Region Name for the UI
        let query = `
            SELECT a.*, r.name as region_name 
            FROM audit_logs a
            LEFT JOIN regions r ON a.region_id = r.id
            WHERE 1=1
        `;
        
        const queryParams = [];
        let counter = 1;

        // --- SECURITY: REGIONAL ADMIN LOCK ---
        if (role === 'REGIONAL_ADMIN' || role === 'ADMIN') {
            query += ` AND a.region_id = $${counter++}`;
            queryParams.push(region_id);
        }
        
        // --- OPTIONAL: SUPER ADMIN FILTER ---
        // If Super Admin selects a specific region in the dropdown
        else if (role === 'SUPER_ADMIN' && region_filter && region_filter !== 'ALL') {
            query += ` AND a.region_id = $${counter++}`;
            queryParams.push(region_filter);
        }

        // Sort by newest first
        query += ` ORDER BY a.created_at DESC LIMIT 500`;
        
        const { rows } = await pool.query(query, queryParams);
        res.status(200).json(rows);

    } catch (error) {
        console.error("Error in Audit Controller: ", error.message);
        res.status(500).json({ message: "Server Error fetching logs." });
    }
};

// Keep the old basic one for backward compatibility if needed, or redirect it
exports.getLogs = exports.filteredLogs;