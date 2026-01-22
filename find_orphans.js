const pool = require('./config/db');

async function findOrphans() {
    try {
        const res = await pool.query(`
            SELECT r.record_id, r.title, r.uploaded_at, o.name as office_name, r.shelf 
            FROM records r
            LEFT JOIN offices o ON r.office_id = o.office_id
            ORDER BY r.uploaded_at DESC
            LIMIT 5;
        `);
        console.table(res.rows);
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

findOrphans();
