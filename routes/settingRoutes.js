const express = require('express');
const router = express.Router();
const settingController = require('../controllers/settingController');
const { authenticateToken } = require('../middleware/authMiddleware');
const upload = require('../middleware/upload');

// Handle multiple files: 'logo' and 'bg'
const uploadFields = upload.fields([{ name: 'logo', maxCount: 1 }, { name: 'bg', maxCount: 1 }]);

router.get('/', settingController.getSettings); // Public access allowed for Login page
router.put('/', authenticateToken, uploadFields, settingController.updateSettings);

module.exports = router;