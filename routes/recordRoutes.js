const express = require('express');
const router = express.Router();
const recordController = require('../controllers/recordController');
const { authenticateToken } = require('../middleware/authMiddleware');
const upload = require('../middleware/upload');

// Base: /api/records

// Create
router.post('/', authenticateToken, upload.single('file'), recordController.createRecord);

// Read
router.get('/', authenticateToken, recordController.getRecords);
router.post('/verify-access/:id', authenticateToken, recordController.verifyRecordAccess);
router.get('/download/:filename', recordController.streamFile); // Public/Tokenized

// Update
router.put('/:id', authenticateToken, recordController.updateRecord);

// Archive / Restore / Destroy
router.put('/:id/archive', authenticateToken, recordController.archiveRecord); // <--- CRITICAL FIX
router.put('/:id/restore', authenticateToken, recordController.restoreRecord);
router.delete('/:id', authenticateToken, recordController.deleteRecord);

module.exports = router;