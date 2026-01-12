const express = require('express');
const router = express.Router();
const recordController = require('../controllers/recordController');
const { authenticateToken } = require('../middleware/authMiddleware');
const upload = require('../middleware/upload');

router.post('/', authenticateToken, upload.single('file'), recordController.createRecord);
router.get('/', authenticateToken, recordController.getRecords);

// NEW: Verification Route
router.post('/:id/verify', authenticateToken, recordController.verifyRecordAccess);

// ... (keep other routes)
router.put('/:id', authenticateToken, recordController.updateRecord);
router.delete('/:id', authenticateToken, recordController.deleteRecord);
router.patch('/:id/archive', authenticateToken, recordController.archiveRecord);
router.patch('/:id/restore', authenticateToken, recordController.restoreRecord);

module.exports = router;