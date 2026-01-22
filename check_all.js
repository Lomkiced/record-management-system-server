const pool = require('./config/db');

async function checkAll() {
    try {
        console.log('--- CHECKING ALL RECORDS ---');
        const res = await pool.query(`
            SELECT record_id, title, shelf, office_id, status, is_restricted 
            FROM records
        `);
        console.table(res.rows);
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

checkAll();
