const pool = require('./config/db');

async function runMigration() {
    try {
        await pool.query(`
            ALTER TABLE records 
            ADD COLUMN IF NOT EXISTS period_covered VARCHAR(255),
            ADD COLUMN IF NOT EXISTS volume VARCHAR(100),
            ADD COLUMN IF NOT EXISTS duplication VARCHAR(100),
            ADD COLUMN IF NOT EXISTS time_value VARCHAR(50),
            ADD COLUMN IF NOT EXISTS utility_value VARCHAR(50);
        `);
        console.log('✅ Migration successful! Columns added.');
    } catch (e) {
        console.error('❌ Migration failed:', e.message);
    } finally {
        pool.end();
    }
}

runMigration();
