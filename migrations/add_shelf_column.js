const pool = require('../config/db');

const runMigration = async () => {
    try {
        console.log("Checking if 'shelf' column exists...");

        // Check if column exists
        const res = await pool.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name='records' AND column_name='shelf';
    `);

        if (res.rows.length === 0) {
            console.log("Adding 'shelf' column to records table...");
            await pool.query(`ALTER TABLE records ADD COLUMN shelf VARCHAR(255) DEFAULT NULL;`);
            console.log("✅ 'shelf' column added successfully.");
        } else {
            console.log("ℹ️ 'shelf' column already exists associated with records table.");
        }

        process.exit(0);
    } catch (err) {
        console.error("❌ Migration Failed:", err);
        process.exit(1);
    }
};

runMigration();
