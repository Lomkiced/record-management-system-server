const pool = require('./config/db');

async function deleteGhost() {
    try {
        // Delete record 44 as requested
        await pool.query("DELETE FROM records WHERE record_id = 44");
        console.log('✅ Deleted Record ID 44');
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

deleteGhost();
