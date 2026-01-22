const pool = require('./config/db');

async function debug50() {
    try {
        console.log('--- RECORD 50 DETAILS ---');
        const res = await pool.query("SELECT * FROM records WHERE is_restricted = true");
        console.table(res.rows);

        const r = res.rows.find(x => x.office_id === 40); // Find the one in ITSM
        if (!r) {
            console.log("No restricted record in Office 40 found.");
            return;
        }
        console.log('Target Record:', r.title, 'Status:', r.status, 'Category:', r.category);

        console.log('\n--- EXECUTING EXACT QUERY ---');
        const query = `
            SELECT DISTINCT shelf 
            FROM records 
            WHERE region_id = $1 
            AND (office_id = $2 OR office_id IN (SELECT office_id FROM offices WHERE parent_id = $2))
            AND category = $3 
            AND status = 'Active'
            AND is_restricted = true
        `;
        // Params from User Toast: Office 27, Region 6, Cat: 'Administrative and Management Records'
        const params = [6, 27, 'Administrative and Management Records'];

        console.log('SQL:', query);
        console.log('Params:', params);

        const qRes = await pool.query(query, params);
        console.log('Rows Returned:', qRes.rows);

        if (qRes.rows.length === 0) {
            console.log("❌ Query Failed. Why?");
            // Let's break it down.
            // 1. Check Region
            if (r.region_id != 6) console.log(`Region Mismatch! Record: ${r.region_id} vs Query: 6`);

            // 2. Check Category
            if (r.category !== 'Administrative and Management Records') console.log(`Category Mismatch! '${r.category}' vs '${params[2]}'`);

            // 3. Check Status
            if (r.status !== 'Active') console.log(`Status Mismatch! Record is '${r.status}'`);

            // 4. Check Office Recursion
            const parents = await pool.query("SELECT parent_id FROM offices WHERE office_id = $1", [r.office_id]);
            const parentId = parents.rows[0]?.parent_id;
            console.log(`Record Office: ${r.office_id}. Parent from DB: ${parentId}. Query expects Parent: 27`);

            if (parentId != 27) console.log("Office Hierarchy Mismatch!");
        } else {
            console.log("✅ Query Succeeded locally.");
        }

    } catch (e) {
        console.error(e);
    } finally {
        pool.end();
    }
}

debug50();
