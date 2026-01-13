const pool = require('./config/db');
const bcrypt = require('bcryptjs');

const forceReset = async () => {
    try {
        console.log("🛠️  FORCING ADMIN ACCOUNT RESET...");
        
        // 1. Generate a valid hash for 'password123'
        const validHash = await bcrypt.hash('password123', 10);
        
        // 2. Delete any existing 'admin' to prevent conflicts
        await pool.query("DELETE FROM users WHERE username = 'admin'");
        
        // 3. Insert the fresh, working admin account
        await pool.query(`
            INSERT INTO users (username, password, role, name, office, status)
            VALUES ($1, $2, 'SUPER_ADMIN', 'System Admin', 'ICT', 'Active')
        `, ['admin', validHash]);

        console.log("✅ SUCCESS! Admin account recreated.");
        console.log("👉 Username: admin");
        console.log("👉 Password: password123");
        process.exit();

    } catch (err) {
        console.error("❌ ERROR:", err.message);
        process.exit(1);
    }
};

forceReset();