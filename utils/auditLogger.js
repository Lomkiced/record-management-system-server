const pool = require('../config/db');

const logAudit = async (req, action, details) => {
    try {
        // Safe Extraction of User Details
        const user = req.user || {};
        const userId = user.id || user.user_id || null;
        const username = user.username || 'System';
        
        // CRITICAL: Capture the Region ID to enable filtering later
        const regionId = user.region_id || null; 

        // Capture IP
        const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress || null;

        const query = `
            INSERT INTO audit_logs (user_id, username, action, details, ip_address, region_id) 
            VALUES ($1, $2, $3, $4, $5, $6)
        `;
        
        // Fire and forget (don't await to keep app fast)
        pool.query(query, [userId, username, action, details, ip, regionId]);

    } catch (err) {
        console.error("Audit Log Failed:", err.message);
    }
};

module.exports = { logAudit };