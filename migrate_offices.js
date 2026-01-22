const pool = require('./config/db');

async function migrate() {
    try {
        console.log('Adding parent_id column to offices table...');
        await pool.query(`
            ALTER TABLE offices 
            ADD COLUMN IF NOT EXISTS parent_id INTEGER REFERENCES offices(office_id) ON DELETE CASCADE;
        `);
        console.log('Migration successful: parent_id added.');
        process.exit(0);
    } catch (err) {
        console.error('Migration failed:', err);
        process.exit(1);
    }
}

migrate();
