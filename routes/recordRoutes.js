const express = require('express');
const router = express.Router();
const recordController = require('../controllers/recordController');
const { authenticateToken } = require('../middleware/authMiddleware');
const upload = require('../middleware/upload');

router.post('/', authenticateToken, upload.single('file'), recordController.createRecord);
router.get('/', authenticateToken, recordController.getRecords);

// --- SECURE DOWNLOAD ROUTES ---
// 1. Verify Password & Get Token
router.post('/:id/verify', authenticateToken, recordController.verifyRecordAccess);

// 2. Stream File (Uses Token for access)
// Note: We don't use 'authenticateToken' here because the image loads in an <iframe> or new tab
// The security is inside the 'token' query parameter.
router.get('/download/:filename', recordController.streamFile);

router.put('/:id', authenticateToken, recordController.updateRecord);
router.delete('/:id', authenticateToken, recordController.deleteRecord);
router.patch('/:id/archive', authenticateToken, recordController.archiveRecord);
router.patch('/:id/restore', authenticateToken, recordController.restoreRecord);

module.exports = router;