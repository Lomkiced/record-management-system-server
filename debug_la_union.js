const pool = require('./config/db');

const checkLaUnion = async () => {
    try {
        console.log("--- CHECKING REGION 3 (La Union) OFFICES ---");
        const offices = await pool.query("SELECT office_id, name, code, region_id, parent_id, status FROM offices WHERE region_id = 3");
        if (offices.rows.length === 0) {
            console.log("No offices found for Region 3.");
        } else {
            offices.rows.forEach(o => {
                console.log(`Office: ${o.name} (${o.code}) | Parent: ${o.parent_id} | Status: ${o.status}`);
            });
        }

    } catch (e) {
        console.error("Error:", e);
    } finally {
        pool.end();
    }
};

checkLaUnion();
