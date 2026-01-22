const pool = require('./config/db');

const run = async () => {
    try {
        console.log('--- LATEST 5 RECORDS ---');
        const res = await pool.query(`
            SELECT r.record_id, r.title, r.office_id, o.code as office_code, o.name as office_name, r.category, r.shelf, r.uploaded_at 
            FROM records r
            LEFT JOIN offices o ON r.office_id = o.office_id
            ORDER BY r.uploaded_at DESC LIMIT 5
        `);
        console.table(res.rows);

        console.log('\n--- OFFICES (ORD & ITSM) ---');
        const offices = await pool.query(`
            SELECT office_id, code, name, parent_office_id, region_id 
            FROM offices 
            WHERE code IN ('ORD', 'ITSM') OR name ILIKE '%Information Technology%'
        `);
        console.table(offices.rows);

    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
};

run();
