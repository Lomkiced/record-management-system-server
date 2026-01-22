const pool = require('./config/db');

async function debugRecent() {
    try {
        console.log('--- RECENT RESTRICTED UPLOADS ---');
        const res = await pool.query(`
            SELECT record_id, title, shelf, office_id, region_id, category, status, is_restricted, uploaded_at 
            FROM records 
            WHERE is_restricted = true
            ORDER BY uploaded_at DESC 
            LIMIT 5
        `);
        console.table(res.rows);

        if (res.rows.length > 0) {
            const r = res.rows[0];
            console.log('\n--- LATEST RECORD ANALYSIS ---');
            console.log(`Title: "${r.title}"`);
            console.log(`Shelf: "${r.shelf}"`);
            console.log(`Cat: "${r.category}"`);
            console.log(`Office: ${r.office_id}`);
            console.log(`Region: ${r.region_id}`);

            // Check Parent
            const parent = await pool.query("SELECT parent_id, name FROM offices WHERE office_id = $1", [r.office_id]);
            console.log(`Parent Office:`, parent.rows[0]);
        }
    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

debugRecent();
