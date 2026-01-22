const pool = require('./config/db');

async function debugRestricted() {
    try {
        console.log('--- 1. RESTRICTED FILES ---');
        const files = await pool.query(`
            SELECT record_id, title, shelf, office_id, region_id, category, status, is_restricted 
            FROM records 
            WHERE is_restricted = true
            ORDER BY record_id DESC
        `);
        console.table(files.rows);

        if (files.rows.length === 0) {
            console.log("No restricted files found.");
            return;
        }

        const sample = files.rows[0];
        console.log('\n--- 2. OFFICE HIERARCHY ---');
        // Check the office of the latest restricted file
        const officeRes = await pool.query("SELECT * FROM offices WHERE office_id = $1", [sample.office_id]);
        console.table(officeRes.rows);

        // If it has a parent, check parent
        let parentId = officeRes.rows[0]?.parent_id;
        if (parentId) {
            console.log(`Checking Parent Office ${parentId}...`);
            const parentRes = await pool.query("SELECT * FROM offices WHERE office_id = $1", [parentId]);
            console.table(parentRes.rows);
        } else {
            console.log("This office has no parent (Top Level).");
            // If it's top level, maybe the file is in a sub-office? 
            // Wait, sample.office_id IS the file's location.
        }

        console.log('\n--- 3. SIMULATING getShelves ---');
        // Let's assume we are viewing the PARENT office (or the same office if top-level)
        // If the file is in a sub-office (ID: sample.office_id), and we view Parent (ID: parentId),
        // The recursive query should find it.

        const targetOfficeId = parentId || sample.office_id;

        const query = `
            SELECT DISTINCT shelf 
            FROM records 
            WHERE region_id = $1 
            AND (office_id = $2 OR office_id IN (SELECT office_id FROM offices WHERE parent_id = $2))
            AND category = $3 
            AND status = 'Active'
            AND is_restricted = true
        `;
        const params = [sample.region_id, targetOfficeId, sample.category];

        console.log(`Querying for Office ID: ${targetOfficeId} (Recursive)`);
        console.log('Params:', params);

        const shelves = await pool.query(query, params);
        console.log('Resulting Shelves:', shelves.rows);

    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

debugRestricted();
