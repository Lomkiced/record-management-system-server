const pool = require('../config/db');

exports.getLogs = async (req, res) => {
    try {
        // Fetch last 100 logs (In production, you'd use pagination)
        const query = `
            SELECT * FROM audit_logs 
            ORDER BY created_at DESC 
            LIMIT 100
        `;
        
        const { rows } = await pool.query(query);
        res.json(rows);
    } catch (err) {
        console.error("Fetch Audit Error:", err.message);
        res.status(500).json({ message: "Server Error" });
    }
};

/**
 * * FILTERED LOGS: Returns filtered logs based on user role level and region
 * @param {*} req 
 * @param {*} res 
 */
exports.filteredLogs = async (req,res) => {
    try {
        const {role, region_id} = req.user;

        if (role === 'STAFF') {
            return res.status(403).json({message: "Access Denied."})
        }

        let query = `SELECT * FROM audit_logs`;
        const queryParams = [];

        //* Filter logic
        if (role === 'REGIONAL_ADMIN') {
            query += ` WHERE region_id = $1`;
            queryParams.push(region_id);
        }
        // filter to latest logs
        query += ` ORDER BY created_at DESC`;
        
        //* Execute query
        const {rows} = await pool.query(query, queryParams);
        res.status(200).json(rows)
    } catch (error) {
        console.error("Error in Regional Logs Controller: ", error.message);
        res.status(500).json({message: "Error in Filtered Logs Controller."})
    }
}