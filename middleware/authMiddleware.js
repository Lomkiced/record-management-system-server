const jwt = require('jsonwebtoken');

// 🔒 CRITICAL: Must match authController.js exactly
const JWT_SECRET = process.env.JWT_SECRET || "dost_secret_key_2025_secure_fix";

exports.authenticateToken = (req, res, next) => {
    // 1. Get header
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // "Bearer <TOKEN>"

    if (!token) {
        return res.status(401).json({ message: "Access Denied: No Token" });
    }

    // 2. Verify
    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            console.error("[AUTH FAIL] Token verification failed:", err.message);
            return res.status(403).json({ message: "Session Expired: Invalid Token" });
        }
        
        // 3. Attach payload to request
        req.user = user;
        next();
    });
};