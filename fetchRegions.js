const pool = require('./config/db');

async function getRegions() {
    try {
        const res = await pool.query('SELECT * FROM regions');
        console.log('REGIONS:', JSON.stringify(res.rows, null, 2));
        process.exit(0);
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

getRegions();
