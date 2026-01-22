const express = require('express');
const router = express.Router();
const officeController = require('../controllers/officeController');
const { authenticateToken } = require('../middleware/authMiddleware');

// Base: /api/offices

// GET all offices (with optional region_id filter)
router.get('/', authenticateToken, officeController.getOffices);

// GET single office by ID
router.get('/:id', authenticateToken, officeController.getOfficeById);

// POST create new office (Admin+ only)
router.post('/', authenticateToken, officeController.createOffice);

// PUT update office
router.put('/:id', authenticateToken, officeController.updateOffice);

// DELETE office (Super Admin only)
router.delete('/:id', authenticateToken, officeController.deleteOffice);

module.exports = router;
