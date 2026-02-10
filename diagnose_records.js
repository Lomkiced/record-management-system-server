const pool = require('./config/db');

async function diagnose() {
    try {
        console.log("Checking 'records' table columns...");
        const res = await pool.query(`
            SELECT column_name, data_type 
            FROM information_schema.columns 
            WHERE table_name = 'records';
        `);
        console.table(res.rows);

        console.log("\nAttempting simple SELECT of new columns...");
        try {
            await pool.query("SELECT media_text, restriction_text, frequency_text, provision_text FROM records LIMIT 1");
            console.log("✅ New columns SELECT successful.");
        } catch (e) {
            console.error("❌ New columns SELECT failed:", e.message);
        }

    } catch (err) {
        console.error("Diagnostic Error:", err);
    } finally {
        pool.end();
    }
}

diagnose();
