const pool = require('./config/db');

const fixSystemSettings = async () => {
    const client = await pool.connect();
    try {
        console.log("🔧 STARTING SYSTEM BRANDING REPAIR...");
        
        await client.query('BEGIN');

        // 1. DROP Table (Clear bad schema/data)
        await client.query("DROP TABLE IF EXISTS system_settings");
        console.log("✅ Old settings table removed.");

        // 2. CREATE Table (Fresh, Correct Schema)
        await client.query(`
            CREATE TABLE system_settings (
                id INT PRIMARY KEY,
                system_name VARCHAR(100) DEFAULT 'DOST-RMS',
                org_name VARCHAR(150) DEFAULT 'Department of Science and Technology',
                welcome_msg TEXT DEFAULT 'Sign in to access the system.',
                primary_color VARCHAR(50) DEFAULT '#4f46e5',
                secondary_color VARCHAR(50) DEFAULT '#0f172a',
                logo_url TEXT,
                login_bg_url TEXT,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                CONSTRAINT single_row_const CHECK (id = 1)
            );
        `);
        console.log("✅ New schema applied.");

        // 3. INSERT Master Row (ID = 1)
        await client.query(`
            INSERT INTO system_settings (id, system_name, org_name, primary_color, secondary_color) 
            VALUES (1, 'DOST-RMS', 'Department of Science and Technology', '#4f46e5', '#0f172a');
        `);
        console.log("✅ Master settings row initialized (ID: 1).");

        await client.query('COMMIT');
        console.log("🚀 REPAIR COMPLETE. Branding system is ready.");

    } catch (err) {
        await client.query('ROLLBACK');
        console.error("❌ FAILED:", err);
    } finally {
        client.release();
        process.exit();
    }
};

fixSystemSettings();