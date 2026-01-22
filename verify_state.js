const pool = require('./config/db');

async function checkState() {
    try {
        console.log('--- CHECKING ACTIVE RECORDS ---');
        const res = await pool.query(`
            SELECT record_id, title, shelf, office_id, region_id, category, status, is_restricted 
            FROM records 
            WHERE status = 'Active'
        `);
        console.table(res.rows);

        console.log('\n--- CHECKING SHELVES QUERY ---');
        if (res.rows.length > 0) {
            const r = res.rows[0];
            // Simulate getShelves query using the file's data
            const query = `
                SELECT DISTINCT shelf 
                FROM records 
                WHERE region_id = $1 
                AND (office_id = $2 OR office_id IN (SELECT office_id FROM offices WHERE parent_id = $2))
                AND category = $3 
                AND status = 'Active'
            `;
            const params = [r.region_id, r.office_id, r.category];
            console.log('Params:', params);

            const shelfRes = await pool.query(query, params);
            console.log('Shelves Found:', shelfRes.rows);
        } else {
            console.log('No Active Records found.');
        }

    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

checkState();
