const pool = require('./config/db');

async function checkHierarchy() {
    try {
        console.log('--- OFFICE HIERARCHY ---');
        const res = await pool.query("SELECT office_id, name, parent_id FROM offices ORDER BY office_id");
        console.table(res.rows);

        console.log('--- RELEVANT RECORDS ---');
        const recs = await pool.query("SELECT record_id, title, office_id FROM records");
        console.table(recs.rows);
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

checkHierarchy();
