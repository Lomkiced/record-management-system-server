const pool = require('./config/db');
const fs = require('fs');
const path = require('path');

async function wipeSystem() {
    const client = await pool.connect();
    try {
        console.log('⚠️  STARTING SYSTEM WIPE...');

        // 1. Get all file paths before deleting DB records
        const res = await client.query("SELECT file_path, is_restricted FROM records");
        const files = res.rows;

        console.log(`📉 Found ${files.length} records to delete.`);

        // 2. Delete All Database Records
        await client.query("DELETE FROM records");
        console.log('✅ Database Truncated.');

        // 3. Delete Physical Files
        let deletedCount = 0;
        const uploadDir = path.join(__dirname, '../uploads');
        const restrictedDir = path.join(__dirname, '../uploads/restricted');

        files.forEach(f => {
            try {
                const targetDir = f.is_restricted ? restrictedDir : uploadDir;
                const filePath = path.join(targetDir, f.file_path);
                if (fs.existsSync(filePath)) {
                    fs.unlinkSync(filePath);
                    deletedCount++;
                }
            } catch (err) {
                console.error(`Failed to delete ${f.file_path}:`, err.message);
            }
        });

        console.log(`🗑️  Physical Files Removed: ${deletedCount}`);

    } catch (e) {
        console.error('❌ Wipe Failed:', e);
    } finally {
        client.release();
        pool.end();
    }
}

wipeSystem();
