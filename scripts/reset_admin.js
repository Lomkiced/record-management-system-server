const bcrypt = require('bcrypt');
const pool = require('./config/db');

async function resetAdminPassword() {
    try {
        const hash = await bcrypt.hash('admin123', 10);
        console.log('Generated hash:', hash);

        await pool.query(
            'UPDATE users SET password = $1 WHERE username = $2',
            [hash, 'admin']
        );

        console.log('Password updated successfully!');
        console.log('Login with: admin / admin123');

        await pool.end();
    } catch (err) {
        console.error('Error:', err);
        process.exit(1);
    }
}

resetAdminPassword();
