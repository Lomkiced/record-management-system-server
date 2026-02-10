const pool = require('./config/db');

async function migrate() {
    try {
        console.log("Applying manual migration...");
        const sql = `
            ALTER TABLE records
            ADD COLUMN IF NOT EXISTS media_text VARCHAR(255),
            ADD COLUMN IF NOT EXISTS restriction_text VARCHAR(255),
            ADD COLUMN IF NOT EXISTS frequency_text VARCHAR(255),
            ADD COLUMN IF NOT EXISTS provision_text VARCHAR(255);
        `;
        await pool.query(sql);
        console.log("✅ Migration applied successfully.");
    } catch (err) {
        console.error("❌ Migration Failed:", err);
    } finally {
        pool.end();
    }
}

migrate();
