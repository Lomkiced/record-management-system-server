const pool = require('../config/db');

exports.getDashboardStats = async (req, res) => {
    try {
        const { region_id } = req.query;

        console.log(`[DASHBOARD] Request received for Region ID: ${region_id}`); // DEBUG LOG

        let pendingQuery, activeQuery, staffQuery, recentQuery;
        let queryParams = [];

        if (region_id) {
            // Force region_id to be an integer to avoid type mismatch
            const regionIdInt = parseInt(region_id); 
            queryParams = [regionIdInt];

            // 1. Count "Pending Approvals" (Flexible check for Pending or Review)
            pendingQuery = pool.query(
                `SELECT COUNT(*) FROM records 
                 WHERE region_id = $1 
                 AND (status ILIKE 'Pending' OR status ILIKE 'Review')`, 
                queryParams
            );

            // 2. Count "Active Projects" (Flexible check for 'Active', 'active', 'ACTIVE')
            activeQuery = pool.query(
                `SELECT COUNT(*) FROM records 
                 WHERE region_id = $1 
                 AND status ILIKE 'Active'`,
                queryParams
            );

            // 3. Count "Staff Online" (Flexible check for Role and Status)
            staffQuery = pool.query(
                `SELECT COUNT(*) FROM users 
                 WHERE region_id = $1 
                 AND role ILIKE 'STAFF' 
                 AND status ILIKE 'ACTIVE'`,
                queryParams
            );

            // 4. Get Recent Submissions
            recentQuery = pool.query(
                `SELECT title, uploaded_at, status FROM records 
                 WHERE region_id = $1 
                 ORDER BY uploaded_at DESC LIMIT 3`,
                queryParams
            );

        } else {
            // Global Fallback
            pendingQuery = pool.query("SELECT COUNT(*) FROM records WHERE status ILIKE 'Pending'");
            activeQuery = pool.query("SELECT COUNT(*) FROM records WHERE status ILIKE 'Active'");
            staffQuery = pool.query("SELECT COUNT(*) FROM users WHERE role ILIKE 'STAFF'");
            recentQuery = pool.query("SELECT title, uploaded_at, status FROM records ORDER BY uploaded_at DESC LIMIT 3");
        }

        // Execute all queries
        const [pendingRes, activeRes, staffRes, recentRes] = await Promise.all([
            pendingQuery,
            activeQuery,
            staffQuery,
            recentQuery
        ]);

        // Log results to terminal so you can verify data exists
        console.log(`[DEBUG] Found: ${activeRes.rows[0].count} Active Projects, ${staffRes.rows[0].count} Staff.`);

        const stats = {
            pendingApprovals: parseInt(pendingRes.rows[0].count),
            activeProjects: parseInt(activeRes.rows[0].count),
            staffOnline: parseInt(staffRes.rows[0].count),
            recent_activity: recentRes.rows
        };

        res.json(stats);

    } catch (err) {
        console.error("Dashboard Stats Error:", err.message);
        res.status(500).json({ message: "Server Error" });
    }
};