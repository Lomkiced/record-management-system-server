/**
 * RETENTION ARCHIVER SERVICE
 * Automatically archives records when their retention period expires.
 * Runs as a scheduled task on server startup.
 */

const pool = require('../config/db');

// Configuration
const CHECK_INTERVAL_MS = 60 * 60 * 1000; // Check every hour
const ENABLE_AUTO_ARCHIVE = true;

/**
 * Check and archive expired records
 * @returns {Object} Result with count of archived records
 */
const archiveExpiredRecords = async () => {
    try {
        const now = new Date();
        console.log(`[RETENTION] Checking for expired records at ${now.toISOString()}`);

        // Find all active records where disposal_date has passed
        const query = `
            UPDATE records 
            SET status = 'Archived'
            WHERE status = 'Active' 
            AND disposal_date IS NOT NULL 
            AND disposal_date <= CURRENT_DATE
            RETURNING record_id, title, disposal_date
        `;

        const result = await pool.query(query);
        const archivedCount = result.rowCount;

        if (archivedCount > 0) {
            console.log(`[RETENTION] ✅ Auto-archived ${archivedCount} expired record(s):`);
            result.rows.forEach(record => {
                console.log(`   - "${record.title}" (ID: ${record.record_id}, Disposal Date: ${record.disposal_date})`);
            });

            // Log to audit trail
            await logRetentionAudit(result.rows);
        } else {
            console.log(`[RETENTION] No expired records found.`);
        }

        return {
            success: true,
            archivedCount,
            records: result.rows
        };
    } catch (err) {
        console.error('[RETENTION] ❌ Error during auto-archive:', err);
        return {
            success: false,
            error: err.message
        };
    }
};

/**
 * Log retention actions to audit trail
 */
const logRetentionAudit = async (records) => {
    try {
        for (const record of records) {
            await pool.query(
                `INSERT INTO audit_logs (user_id, action, details, ip_address, created_at)
                 VALUES (NULL, 'AUTO_ARCHIVE', $1, 'SYSTEM', NOW())`,
                [`Retention period expired - Auto-archived "${record.title}" (ID: ${record.record_id})`]
            );
        }
    } catch (err) {
        console.error('[RETENTION] Failed to log audit:', err);
    }
};

/**
 * Get retention status summary
 */
const getRetentionSummary = async () => {
    try {
        const result = await pool.query(`
            SELECT 
                COUNT(*) FILTER (WHERE status = 'Active' AND disposal_date IS NOT NULL AND disposal_date <= CURRENT_DATE) as expired,
                COUNT(*) FILTER (WHERE status = 'Active' AND disposal_date IS NOT NULL AND disposal_date > CURRENT_DATE AND disposal_date <= CURRENT_DATE + INTERVAL '7 days') as expiring_soon,
                COUNT(*) FILTER (WHERE status = 'Active' AND disposal_date IS NOT NULL AND disposal_date > CURRENT_DATE + INTERVAL '7 days') as active,
                COUNT(*) FILTER (WHERE status = 'Archived') as archived
            FROM records
        `);
        return result.rows[0];
    } catch (err) {
        console.error('[RETENTION] Error getting summary:', err);
        return null;
    }
};

/**
 * Initialize the retention scheduler
 */
const initRetentionScheduler = () => {
    if (!ENABLE_AUTO_ARCHIVE) {
        console.log('[RETENTION] Auto-archive is disabled.');
        return;
    }

    console.log('[RETENTION] 🚀 Retention Archiver Service initialized');
    console.log(`[RETENTION] Check interval: ${CHECK_INTERVAL_MS / 1000 / 60} minutes`);

    // Run immediately on startup
    setTimeout(async () => {
        console.log('[RETENTION] Running initial check...');
        await archiveExpiredRecords();
    }, 5000); // Wait 5 seconds after server starts

    // Then run periodically
    setInterval(async () => {
        await archiveExpiredRecords();
    }, CHECK_INTERVAL_MS);
};

// Export for use in routes and manual triggers
module.exports = {
    archiveExpiredRecords,
    getRetentionSummary,
    initRetentionScheduler
};
