const pool = require('./config/db');

async function run() {
    try {
        console.log("--- DEBUGGER STARTED ---");

        // 1. Get Latest 5 Records
        const res = await pool.query(`
            SELECT 
                r.record_id, 
                r.title, 
                r.region_id, 
                reg.name as region_name,
                r.office_id, 
                o.name as office_name,
                o.parent_id as office_parent_id,
                r.shelf, 
                r.status,
                r.is_restricted,
                r.uploaded_at,
                u.username,
                u.role
            FROM records r
            LEFT JOIN offices o ON r.office_id = o.office_id
            LEFT JOIN regions reg ON r.region_id = reg.id
            LEFT JOIN users u ON r.uploaded_by = u.user_id
            ORDER BY r.uploaded_at DESC
            LIMIT 5
        `);
        console.log("\nLatest 5 Records:");
        console.table(res.rows);

        // 2. Check "ITSM" Office Details
        const itsmCheck = await pool.query(`SELECT office_id, name, parent_id, region_id, code FROM offices WHERE name ILIKE '%ITSM%' OR code ILIKE '%ITSM%'`);
        console.log("\nITSM Office Details:");
        console.table(itsmCheck.rows);

        if (itsmCheck.rows.length > 0) {
            const itsm = itsmCheck.rows[0];
            // 3. Check Parent of ITSM
            if (itsm.parent_id) {
                const parentCheck = await pool.query(`SELECT office_id, name, code, region_id FROM offices WHERE office_id = $1`, [itsm.parent_id]);
                console.log("\nParent Office Details (for ITSM):");
                console.table(parentCheck.rows);
            }
        }

    } catch (err) {
        console.error("DEBUG ERROR:", err);
    } finally {
        // Don't close pool if it's singleton, but usually for script we exit
        console.log("--- DEBUGGER FINISHED ---");
        process.exit();
    }
}

run();
