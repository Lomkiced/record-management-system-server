// server/routes/profileRoutes.js
const router = require('express').Router();
const authenticateToken = require('../middleware/authorization'); // ⚠️ Check this path matches your auth middleware
const { getProfile, updateProfile, updatePassword } = require('../controllers/profileController');

// Protect all these routes with the token middleware
router.get('/', authenticateToken, getProfile);
router.put('/', authenticateToken, updateProfile);
router.put('/password', authenticateToken, updatePassword);

module.exports = router;