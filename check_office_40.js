const pool = require('./config/db');

async function check40() {
    try {
        console.log('Checking Office 40...');
        const res = await pool.query("SELECT * FROM offices WHERE office_id = 40");
        console.table(res.rows);
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

check40();
