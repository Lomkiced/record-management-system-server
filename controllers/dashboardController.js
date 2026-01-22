const pool = require('../config/db');

exports.getDashboardStats = async (req, res) => {
    try {
        // 🔒 IDENTITY RECOVERY: Standardize User ID Access
        const { role, region_id } = req.user;
        const user_id = req.user.id || req.user.user_id;

        let filterClause = "";
        let params = [];

        // 1. DYNAMIC FILTERING
        let metricsFilter = "";
        let metricsParams = [];
        let disposalFilter = "";
        let disposalParams = [];

        if (role === 'REGIONAL_ADMIN') {
            metricsFilter = " WHERE region_id = $1";
            metricsParams = [region_id];

            disposalFilter = " WHERE region_id = $1";
            disposalParams = [region_id];
        } else if (role === 'STAFF') {
            // METRICS: Personal (My Uploads)
            metricsFilter = " WHERE uploaded_by = $1";
            metricsParams = [user_id];

            // DISPOSAL: Regional (Team View - so they can act on office records)
            disposalFilter = " WHERE region_id = $1";
            disposalParams = [region_id];
        }

        // 2. FETCH DATA
        const [recordStats, storageStats, disposalQueue, recentLogs] = await Promise.all([
            pool.query(`SELECT COUNT(*) FROM records ${metricsFilter}`, metricsParams),
            pool.query(`SELECT SUM(file_size) as total_bytes FROM records ${metricsFilter}`, metricsParams),
            pool.query(`
                SELECT record_id, title, disposal_date, retention_period, status, is_restricted 
                FROM records 
                ${disposalFilter ? disposalFilter + " AND" : "WHERE"} status = 'Active' 
                AND disposal_date IS NOT NULL
                AND disposal_date <= (CURRENT_DATE + INTERVAL '7 days')
                ORDER BY disposal_date ASC 
                LIMIT 50
            `, disposalParams),
            (role === 'SUPER_ADMIN' || role === 'ADMIN')
                ? pool.query("SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT 5")
                : pool.query(`SELECT a.* FROM audit_logs a JOIN users u ON a.user_id = u.user_id WHERE u.region_id = $1 ORDER BY a.created_at DESC LIMIT 5`, [region_id || 0])
        ]);

        // 3. REGION STATS
        let regionData = { total: 1, active: 1, inactive: 0 };
        if (role === 'SUPER_ADMIN' || role === 'ADMIN') {
            const rStats = await pool.query("SELECT COUNT(*) as total, SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) as active FROM regions");
            regionData = {
                total: parseInt(rStats.rows[0].total),
                active: parseInt(rStats.rows[0].active),
                inactive: parseInt(rStats.rows[0].total) - parseInt(rStats.rows[0].active)
            };
        }

        // 4. USERS COUNT (STRICT)
        let userCountQuery;
        let userParams;
        if (role === 'SUPER_ADMIN' || role === 'ADMIN') {
            userCountQuery = "SELECT COUNT(*) FROM users";
            userParams = [];
        } else {
            userCountQuery = "SELECT COUNT(*) FROM users WHERE region_id = $1 AND UPPER(role) = 'STAFF'";
            userParams = [region_id || null];
        }

        // 5. ANALYTICS QUERY (Monthly & Office Stats)
        console.log(`[DASHBOARD] Fetching Stats - Role: ${role}, Region: ${region_id}`); // DEBUG

        // Allow ADMIN to see Global Stats (same as SUPER_ADMIN), only restrict REGIONAL_ADMIN and STAFF
        // Allow ADMIN to see Global Stats (same as SUPER_ADMIN), only restrict REGIONAL_ADMIN and STAFF
        const isGlobalView = role === 'SUPER_ADMIN' || role === 'ADMIN';
        const isStaff = role === 'STAFF';

        const safeRegionId = region_id || null; // Prevent undefined binding error

        // Define partitioning variables
        let analyticsParams = [];
        let officeFilter = "";
        let monthlyFilter = "";

        if (isGlobalView) {
            analyticsParams = [];
            officeFilter = ""; // No additional filter on office
            monthlyFilter = "WHERE";
        } else if (isStaff) {
            // STAFF: Personal Analytics
            analyticsParams = [user_id];
            // Reuse office_stats query for "Category Breakdown" or similar context if needed, 
            // but currently office_stats query groups by office_id. 
            // Ideally we'd modify the query itself, but for now we filter by uploader so they see only offices they uploaded to (likely 1).
            officeFilter = "WHERE r.uploaded_by = $1";
            monthlyFilter = "WHERE uploaded_by = $1 AND";
        } else {
            // REGIONAL ADMIN
            analyticsParams = [safeRegionId];
            officeFilter = "WHERE o.region_id = $1";
            monthlyFilter = "WHERE region_id = $1 AND";
        }

        const [userCount, officeStats, monthlyStats] = await Promise.all([
            pool.query(userCountQuery, userParams),
            // Office Performance: Active files & Storage by Office
            pool.query(`
                SELECT o.code as name, COUNT(r.record_id) as value, SUM(r.file_size) as bytes 
                FROM offices o 
                LEFT JOIN records r ON o.office_id = r.office_id AND r.status = 'Active'
                ${officeFilter}
                GROUP BY o.office_id, o.code
                ORDER BY value DESC
             `, analyticsParams),
            // Monthly Trends: Last 6 Months
            pool.query(`
                SELECT TO_CHAR(uploaded_at, 'Mon') as name, COUNT(*) as value 
                FROM records 
                ${monthlyFilter} uploaded_at >= NOW() - INTERVAL '6 months'
                GROUP BY TO_CHAR(uploaded_at, 'Mon'), DATE_TRUNC('month', uploaded_at)
                ORDER BY DATE_TRUNC('month', uploaded_at) ASC
             `, analyticsParams)
        ]);

        // 5. RESPONSE
        res.json({
            users: parseInt(userCount.rows[0].count),
            records: parseInt(recordStats.rows[0].count),
            storage: parseInt(storageStats.rows[0].total_bytes) || 0,
            regions: regionData,
            recent_activity: recentLogs.rows || [],
            disposal_queue: disposalQueue.rows || [],
            office_stats: officeStats.rows || [],
            monthly_stats: monthlyStats.rows || []
        });

    } catch (err) {
        console.error("Dashboard Error:", err.message);
        res.status(500).json({ message: "Server Error" });
    }
};