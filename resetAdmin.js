const pool = require('./config/db');
const bcrypt = require('bcryptjs');

const resetAdmin = async () => {
    const client = await pool.connect();
    try {
        console.log("🔄 STARTING ADMIN RESET...");

        const username = 'admin';
        const passwordPlain = 'password123';
        const hashedPassword = await bcrypt.hash(passwordPlain, 10);

        await client.query('BEGIN');

        // 1. Delete existing admin to clear bad states
        await client.query("DELETE FROM users WHERE username = $1", [username]);
        console.log("✅ Old admin account removed (if existed).");

        // 2. Create Fresh Super Admin
        const insertQuery = `
            INSERT INTO users (username, password, role, name, office, status, region_id)
            VALUES ($1, $2, 'SUPER_ADMIN', 'System Administrator', 'ICT Unit', 'Active', NULL)
            RETURNING user_id;
        `;
        
        await client.query(insertQuery, [username, hashedPassword]);
        
        await client.query('COMMIT');
        console.log(`
        ===========================================
        ✅ SUCCESS! Admin User Created.
        -------------------------------------------
        👤 Username:  admin
        🔑 Password:  password123
        ===========================================
        `);

    } catch (error) {
        await client.query('ROLLBACK');
        console.error("❌ FAILED:", error);
    } finally {
        client.release();
        process.exit();
    }
};

resetAdmin();