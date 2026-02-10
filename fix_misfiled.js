const pool = require('./config/db');

async function fixMisfiled() {
    try {
        console.log("--- RECORD REPAIR UTILITY ---");

        // 1. Identify the user 'nerve' and their assigned office
        const userRes = await pool.query("SELECT user_id, username, role FROM users WHERE username = 'nerve'");
        if (userRes.rows.length === 0) {
            console.log("User 'nerve' not found.");
            process.exit();
        }
        const user = userRes.rows[0];
        console.log(`Target User: ${user.username} (ID: ${user.user_id})`);

        // 2. Identify the target Sub-Office (ITSM) and its Parent (ORD)
        // We look for ITSM
        const itsmRes = await pool.query("SELECT office_id, name, parent_id FROM offices WHERE name ILIKE '%Information Technology%' OR code = 'ITSM'");
        if (itsmRes.rows.length === 0) {
            console.log("ITSM Office not found.");
            process.exit();
        }
        const itsm = itsmRes.rows[0];
        console.log(`Target Sub-Office: ${itsm.name} (ID: ${itsm.office_id})`);

        if (!itsm.parent_id) {
            console.log("ITSM has no parent. Aborting logic.");
            process.exit();
        }
        console.log(`Parent Office ID: ${itsm.parent_id}`);

        // 3. Find records uploaded by this user to the PARENT office (Misfiled)
        const misfiledRes = await pool.query(`
            SELECT record_id, title, office_id 
            FROM records 
            WHERE uploaded_by = $1 AND office_id = $2
        `, [user.user_id, itsm.parent_id]);

        console.log(`\nFound ${misfiledRes.rows.length} potentially misfiled records (in Parent Office):`);
        console.table(misfiledRes.rows);

        if (misfiledRes.rows.length > 0) {
            // 4. Update them to the Sub-Office
            const updateRes = await pool.query(`
                UPDATE records 
                SET office_id = $1 
                WHERE uploaded_by = $2 AND office_id = $3
                RETURNING record_id, title
            `, [itsm.office_id, user.user_id, itsm.parent_id]);

            console.log(`\n✅ SUCCESSFULLY MOVED ${updateRes.rowCount} RECORD(S) TO ITSM (ID: ${itsm.office_id})`);
        } else {
            console.log("\nNo misfiled records found to fix.");
        }

    } catch (err) {
        console.error("Error:", err);
    } finally {
        process.exit();
    }
}

fixMisfiled();
