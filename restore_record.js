const pool = require('./config/db');

async function restoreRecord() {
    try {
        await pool.query("UPDATE records SET status = 'Active' WHERE record_id = 48");
        console.log('✅ Restored Record 48 to Active status.');
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

restoreRecord();
