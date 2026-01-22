const express = require('express');
const router = express.Router();
const recordController = require('../controllers/recordController');
const { authenticateToken } = require('../middleware/authMiddleware');
const upload = require('../middleware/upload');

// Base: /api/records

// --- 1. SPECIFIC ACTION ROUTES (PRIORITY HIGH) ---
router.put('/:id/archive', authenticateToken, recordController.archiveRecord);
router.put('/:id/restore', authenticateToken, recordController.restoreRecord);
// router.get('/download/:filename', recordController.streamFile);
router.get('/stream/:filename', recordController.streamFile);
router.post('/:id/verify', authenticateToken, recordController.verifyRecordAccess);

// --- 2. GENERAL ROUTES ---
router.post('/', authenticateToken, upload.single('file'), recordController.createRecord);
router.get('/', authenticateToken, recordController.getRecords);
router.get('/shelves', authenticateToken, recordController.getShelves);
router.post('/shelves/delete', authenticateToken, recordController.deleteShelf);

// --- RETENTION ARCHIVER (Manual Trigger) ---
router.post('/retention/process', authenticateToken, async (req, res) => {
    try {
        const { archiveExpiredRecords } = require('../services/retentionService');
        const result = await archiveExpiredRecords();
        res.json({
            message: `Retention check complete. ${result.archivedCount} record(s) archived.`,
            ...result
        });
    } catch (err) {
        console.error('Retention trigger error:', err);
        res.status(500).json({ message: 'Failed to run retention check' });
    }
});

// --- 3. GENERIC ID ROUTES (PRIORITY LOW) ---
router.put('/:id', authenticateToken, recordController.updateRecord);
router.delete('/:id', authenticateToken, recordController.deleteRecord);

module.exports = router;