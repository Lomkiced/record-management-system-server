const pool = require('./config/db');

async function checkLogs() {
    try {
        console.log('--- AUDIT LOGS ---');
        const res = await pool.query(`
            SELECT timestamp, action, details, user_id, ip_address 
            FROM audit_logs 
            ORDER BY timestamp DESC 
            LIMIT 10
        `);
        console.table(res.rows);
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

checkLogs();
