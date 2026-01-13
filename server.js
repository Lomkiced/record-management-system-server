require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs'); 
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

// --- ROUTE IMPORTS ---
const authRoutes = require('./routes/authRoutes');
const recordRoutes = require('./routes/recordRoutes');
const dashboardRoutes = require('./routes/dashboardRoutes');
const userRoutes = require('./routes/userRoutes');
const codexRoutes = require('./routes/codexRoutes'); 
const regionRoutes = require('./routes/regionRoutes');
const auditRoutes = require('./routes/auditRoutes');

const app = express();
const port = process.env.PORT || 5000;

// --- 1. SECURITY MIDDLEWARE (The Fix) ---
// We customize Helmet to allow the Frontend (port 5173) to display files in an iframe
app.use(helmet({
    crossOriginResourcePolicy: { policy: "cross-origin" }, // Allows resources (images/pdfs) to be loaded by other origins
    contentSecurityPolicy: {
        directives: {
            ...helmet.contentSecurityPolicy.getDefaultDirectives(),
            // CRITICAL: Allow localhost:5173 to embed (frame) this server's content
            "frame-ancestors": ["'self'", "http://localhost:5173"], 
        },
    },
}));

app.use(cors({ origin: 'http://localhost:5173', credentials: true })); 
app.use(express.json({ limit: '50mb' })); 
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// Rate Limiter
const loginLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, 
    max: 10, 
    message: "Too many login attempts, please try again later."
});
app.use('/api/auth/login', loginLimiter);

// --- 2. TRAFFIC MONITOR ---
app.use((req, res, next) => {
    console.log(`[REQUEST] ${req.method} ${req.url}`);
    next();
});

// --- 3. SECURE FILE STORAGE ---
// Ensure folder exists, but DO NOT expose it statically.
// Files are served via the 'streamFile' controller only.
const uploadDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// --- 4. API ROUTES ---
app.use('/api/auth', authRoutes);
app.use('/api/records', recordRoutes);
app.use('/api/dashboard', dashboardRoutes); 
app.use('/api/users', userRoutes);
app.use('/api/codex', codexRoutes);
app.use('/api/regions', regionRoutes);
app.use('/api/audit', auditRoutes);

// --- 5. GLOBAL ERROR HANDLER ---
app.use((err, req, res, next) => {
    console.error("🔥 UNHANDLED ERROR:", err.stack);
    res.status(500).json({ message: "Internal System Failure", error: err.message });
});

// --- 6. START SERVER ---
app.listen(port, () => {
    console.log(`🚀 SERVER ONLINE on http://localhost:${port}`);
});