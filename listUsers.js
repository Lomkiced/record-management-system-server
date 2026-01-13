const pool = require('./config/db');

const listUsers = async () => {
    try {
        console.log("\n📋 CURRENT DATABASE USERS:");
        console.log("---------------------------------------------------------------------------------");
        console.log(String("ID").padEnd(5) + String("USERNAME").padEnd(20) + String("ROLE").padEnd(20) + String("REGION").padEnd(10) + String("STATUS"));
        console.log("---------------------------------------------------------------------------------");

        const res = await pool.query("SELECT user_id, username, role, region_id, status FROM users ORDER BY user_id ASC");
        
        res.rows.forEach(u => {
            console.log(
                String(u.user_id).padEnd(5) + 
                String(u.username).padEnd(20) + 
                String(u.role).padEnd(20) + 
                String(u.region_id || '-').padEnd(10) + 
                String(u.status)
            );
        });
        console.log("---------------------------------------------------------------------------------\n");
        process.exit();
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
};

listUsers();