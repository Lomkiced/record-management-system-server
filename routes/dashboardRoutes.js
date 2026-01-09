const express = require('express');
const router = express.Router();
const dashboardController = require('../controllers/dashboardController');
// Import the Security Guard
const { authenticateToken } = require('../middleware/authMiddleware');

// FIX: We add 'authenticateToken' here to protect the route
router.get('/stats', authenticateToken, dashboardController.getDashboardStats);

module.exports = router;