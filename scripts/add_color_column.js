const pool = require('../config/db');

async function runMigration() {
    try {
        const client = await pool.connect();
        console.log('Connected to database...');

        try {
            console.log('Adding color column to codex_categories table...');
            await client.query("ALTER TABLE codex_categories ADD COLUMN IF NOT EXISTS color VARCHAR(50) DEFAULT 'amber'");
            console.log('Migration successful!');
        } catch (err) {
            console.error('Error running migration:', err);
        } finally {
            client.release();
        }
    } catch (err) {
        console.error('Error connecting to database:', err);
    } finally {
        pool.end();
    }
}

runMigration();
