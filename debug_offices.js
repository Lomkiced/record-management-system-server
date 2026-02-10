const pool = require('./config/db');

const checkOffices = async () => {
    try {
        console.log("--- CHECKING REGIONS ---");
        const regions = await pool.query("SELECT * FROM regions");
        regions.rows.forEach(r => console.log(`Region: ${r.id} - ${r.name}`));

        console.log("\n--- CHECKING OFFICES (First 20) ---");
        const offices = await pool.query("SELECT office_id, name, code, region_id, parent_id FROM offices LIMIT 20");
        offices.rows.forEach(o => {
            console.log(`Office: ${o.name} (${o.code}) | Region: ${o.region_id} | Parent: ${o.parent_id}`);
        });

        console.log("\n--- CHECKING USERS ROLES (Distinct) ---");
        const roles = await pool.query("SELECT DISTINCT role FROM users");
        roles.rows.forEach(r => console.log(`Role: ${r.role}`));

    } catch (e) {
        console.error("Error:", e);
    } finally {
        pool.end();
    }
};

checkOffices();
