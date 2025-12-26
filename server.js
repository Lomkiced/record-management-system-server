const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');
const fs = require('fs'); 
const { spawn } = require('child_process'); 
require('dotenv').config();

// INITIALIZE
const app = express();
const port = process.env.PORT || 5000;
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('uploads'));

// STORAGE CONFIGURATION
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = 'uploads/';
    if (!fs.existsSync(uploadPath)) fs.mkdirSync(uploadPath);
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage: storage });

// DATABASE CONNECTION
const pool = new Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_DATABASE, // Ensure this matches 'dost_rms'
});

// ==========================================
//      ENTERPRISE SECURITY MIDDLEWARE
// ==========================================

// 1. HELPERS
const logAction = async (userId, action, details, req) => {
  try {
    // Enterprise Audit: Tracks Region if available
    const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
    const regionId = req.user ? req.user.region_id : null; 
    
    await pool.query(
      "INSERT INTO audit_logs (user_id, action, details, ip_address, region_id) VALUES ($1, $2, $3, $4, $5)", 
      [userId, action, details, ip, regionId]
    );
  } catch (err) { console.error("Audit Log Failed:", err.message); }
};

const calculateDisposalDate = (retentionStr) => {
  if (!retentionStr) return null;
  const lower = retentionStr.toString().toLowerCase();
  if (lower.includes('permanent')) return null;
  const years = parseInt(lower.match(/\d+/));
  if (!isNaN(years) && years > 0) {
    const now = new Date();
    now.setFullYear(now.getFullYear() + years);
    return now;
  }
  return null;
};

// 2. AUTHENTICATION (Identity Check)
// Fetches LATEST role/region from DB every request (Stateless but Secure)
const authenticateToken = async (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (token == null) return res.sendStatus(401);

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || "my_secret_key_123");
    
    // FETCH LIVE USER DATA
    const userQuery = await pool.query(
      "SELECT user_id, username, role, region_id, office, status FROM users WHERE user_id = $1", 
      [decoded.id]
    );

    if (userQuery.rows.length === 0) return res.sendStatus(403);
    const user = userQuery.rows[0];

    // Check Account Status
    if (user.status !== 'ACTIVE') return res.status(403).json({ message: "Account Suspended" });

    req.user = user; // Attach full context
    next();
  } catch (err) {
    return res.sendStatus(403);
  }
};

// 3. REGION ISOLATION (Data Sovereignty)
// Injects SQL clauses to force data scoping
const scopeDataByRegion = (req, res, next) => {
  if (req.user.role === 'SUPER_ADMIN') {
    // God Mode: No filters
    req.sqlFilter = ""; 
    req.sqlParams = [];
  } else {
    // Strict Mode: Filter by Region ID
    req.sqlFilter = " AND region_id = $1"; 
    req.sqlParams = [req.user.region_id];
  }
  next();
};

// ==========================================
//                 ROUTES
// ==========================================

// --- 1. DASHBOARD STATS (Scoped) ---
app.get("/api/stats", authenticateToken, scopeDataByRegion, async (req, res) => {
  try {
    // Dynamic Query Construction
    const query = `SELECT status, COUNT(*) FROM records WHERE 1=1 ${req.sqlFilter} GROUP BY status`;
    const stats = await pool.query(query, req.sqlParams);

    const statsObj = { Active: 0, Mature: 0, Archived: 0, Total: 0 };
    let totalCalculated = 0;

    stats.rows.forEach(row => {
       if (!row.status) return; 
       const key = row.status.charAt(0).toUpperCase() + row.status.slice(1).toLowerCase();
       if (statsObj[key] !== undefined) statsObj[key] = parseInt(row.count);
       totalCalculated += parseInt(row.count);
    });

    statsObj.Total = totalCalculated;
    res.json(statsObj);
  } catch (err) { res.status(500).send("Server Error"); }
});

// --- 2. RECORDS CRUD (Strictly Scoped) ---

// GET RECORDS
app.get("/api/records", authenticateToken, scopeDataByRegion, async (req, res) => {
  try {
    const { search, category, page = 1, limit = 10, filterStatus } = req.query;
    const offset = (page - 1) * limit;

    // Auto-update maturity (Could be moved to a cron job for enterprise scale)
    await pool.query(`UPDATE records SET status = 'Mature' WHERE disposal_date < NOW() AND status = 'Active'`);

    // Base Query with Region Scope
    let baseQuery = `FROM records WHERE 1=1 ${req.sqlFilter}`;
    
    // Dynamic Parameter Handling
    // If Regional Admin, req.sqlParams has [region_id] (Index $1)
    // If Super Admin, req.sqlParams is [] (Empty)
    let params = [...req.sqlParams]; 
    let counter = params.length + 1; 

    if (search) { baseQuery += ` AND title ILIKE $${counter}`; params.push(`%${search}%`); counter++; }
    if (category && category !== 'All') { baseQuery += ` AND category = $${counter}`; params.push(category); counter++; }

    if (filterStatus === 'Archived') {
      baseQuery += ` AND status = 'Archived'`;
    } else {
      baseQuery += ` AND status IN ('Active', 'Mature', 'Pending')`;
    }

    // Execute
    const countRes = await pool.query(`SELECT COUNT(*) ${baseQuery}`, params);
    const dataRes = await pool.query(`SELECT * ${baseQuery} ORDER BY record_id DESC LIMIT $${counter} OFFSET $${counter+1}`, [...params, limit, offset]);

    res.json({
      total: parseInt(countRes.rows[0].count),
      totalPages: Math.ceil(parseInt(countRes.rows[0].count) / limit),
      data: dataRes.rows
    });
  } catch (err) { res.status(500).send(err.message); }
});

// CREATE RECORD (Auto-Assign Region)
app.post("/api/records", authenticateToken, upload.single('file'), async (req, res) => {
  try {
    const { title, category, retention_period } = req.body;
    const filePath = req.file ? req.file.filename : null; 
    const disposalDate = calculateDisposalDate(retention_period);

    // SECURITY: Force assign record to Creator's Region
    // Super Admins default to NULL (Global) or specific if provided (advanced logic omitted for brevity)
    const regionId = req.user.role === 'SUPER_ADMIN' ? null : req.user.region_id;

    if (!regionId && req.user.role !== 'SUPER_ADMIN') {
        return res.status(400).json({message: "User context missing region."});
    }

    const newRecord = await pool.query(
      "INSERT INTO records (title, status, category, file_path, disposal_date, region_id) VALUES ($1, 'Active', $2, $3, $4, $5) RETURNING *",
      [title, category || 'Unclassified', filePath, disposalDate, regionId]
    );
    
    logAction(req.user.user_id, 'CREATE_RECORD', `Created: ${title}`, req);
    res.json(newRecord.rows[0]);
  } catch (err) { res.status(500).send("Server Error: " + err.message); }
});

// UPDATE RECORD (Region Protected)
app.put("/api/records/:id", authenticateToken, scopeDataByRegion, upload.single('file'), async (req, res) => {
    try {
        const { id } = req.params;
        const { title, category, retention_period } = req.body;
        const filePath = req.file ? req.file.filename : undefined; 
        const disposalDate = calculateDisposalDate(retention_period);

        // Security: Ensure record belongs to user's region before updating
        let checkQuery = `SELECT * FROM records WHERE record_id = $1 ${req.sqlFilter}`;
        let checkParams = [id, ...req.sqlParams];
        const check = await pool.query(checkQuery, checkParams);
        if(check.rows.length === 0) return res.status(403).json("Access Denied or Record Not Found");

        let query = "UPDATE records SET title = $1, category = $2";
        let params = [title, category];
        let counter = 3;

        if (disposalDate !== null) {
            query += `, disposal_date = $${counter}, status = 'Active'`;
            params.push(disposalDate);
            counter++;
        }
        if (filePath) {
            query += `, file_path = $${counter}`;
            params.push(filePath);
            counter++;
        }

        query += ` WHERE record_id = $${counter} RETURNING *`;
        params.push(id);

        const updated = await pool.query(query, params);
        logAction(req.user.user_id, 'UPDATE_RECORD', `Updated record: ${title}`, req);
        res.json(updated.rows[0]);
    } catch (err) { res.status(500).send("Server Error"); }
});

// DELETE RECORD (Region Protected)
app.delete("/api/records/:id", authenticateToken, scopeDataByRegion, async (req, res) => {
    try {
        // Security Check
        let checkQuery = `SELECT * FROM records WHERE record_id = $1 ${req.sqlFilter}`;
        let checkParams = [req.params.id, ...req.sqlParams];
        const check = await pool.query(checkQuery, checkParams);
        if(check.rows.length === 0) return res.status(403).json("Access Denied or Record Not Found");

        await pool.query("DELETE FROM records WHERE record_id = $1", [req.params.id]);
        logAction(req.user.user_id, 'DELETE', `Deleted Record #${req.params.id}`, req);
        res.json("Deleted");
    } catch (err) { res.status(500).send("Server Error"); }
});

// --- 3. USER MANAGEMENT (Admin) ---
app.post("/api/users", authenticateToken, async (req, res) => { 
    try {
        // Only Super Admins or Regional Admins can create users
        if(req.user.role === 'STAFF') return res.status(403).json("Unauthorized");

        const { username, password, full_name, office, role, region_id } = req.body; 
        
        // Validation: Regional Admins can only create users for THEIR region
        if(req.user.role === 'REGIONAL_ADMIN' && region_id !== req.user.region_id) {
            return res.status(403).json("Cannot create users for other regions");
        }

        const hp = await bcrypt.hash(password, 10); 
        const n = await pool.query(
            "INSERT INTO users (username, password_hash, full_name, office, role, region_id, status) VALUES ($1, $2, $3, $4, $5, $6, 'ACTIVE') RETURNING *", 
            [username, hp, full_name, office, role || 'STAFF', region_id || req.user.region_id]
        ); 
        logAction(req.user.user_id, 'CREATE_USER', `Created user ${username}`, req);
        res.json(n.rows[0]); 
    } catch (err) { res.status(500).send(err.message); }
});

// --- 4. PROFILE & LOGS ---

app.get("/api/profile", authenticateToken, async (req, res) => {
  try {
    // Return the user from the token (already fetched in middleware)
    const { user_id, username, role, region_id, office } = req.user;
    
    // Fetch detailed profile
    const result = await pool.query("SELECT full_name, email, phone, bio, avatar_url, location FROM users WHERE user_id = $1", [user_id]);
    const details = result.rows[0];

    res.json({
      fullName: details.full_name,
      email: details.email,
      phone: details.phone,
      department: office,
      role: role,
      regionId: region_id,
      location: details.location,
      bio: details.bio,
      avatarUrl: details.avatar_url
    });
  } catch (err) { res.status(500).send("Server Error"); }
});

// ENTERPRISE LOGS (Scoped)
app.get("/api/logs", authenticateToken, scopeDataByRegion, async (req, res) => {
  try {
    const { page = 1, limit = 20, search } = req.query;
    const offset = (page - 1) * limit;

    // Start Query
    let baseQuery = `FROM audit_logs l LEFT JOIN users u ON l.user_id = u.user_id WHERE 1=1 ${req.sqlFilter}`;
    
    // Dynamic Params
    let params = [...req.sqlParams];
    let counter = params.length + 1;

    if (search) {
      baseQuery += ` AND (u.username ILIKE $${counter} OR l.action ILIKE $${counter})`;
      params.push(`%${search}%`);
      counter++;
    }

    const countRes = await pool.query(`SELECT COUNT(*) ${baseQuery}`, params);
    const dataQuery = `SELECT l.*, u.username, u.avatar_url ${baseQuery} ORDER BY l.created_at DESC LIMIT $${counter} OFFSET $${counter+1}`;
    
    const logs = await pool.query(dataQuery, [...params, limit, offset]);

    res.json({
      data: logs.rows,
      pagination: { total: parseInt(countRes.rows[0].count), page: parseInt(page) }
    });

  } catch (err) { res.status(500).send(err.message); }
});

// --- 5. AUTHENTICATION ---
app.post("/api/login", async (req, res) => {
    try {
      const { username, password } = req.body;
      const user = await pool.query("SELECT * FROM users WHERE username = $1", [username]);
      if (user.rows.length === 0) return res.status(401).json("Invalid Credentials");
      
      const valid = await bcrypt.compare(password, user.rows[0].password_hash);
      if (!valid) return res.status(401).json("Invalid Credentials");
      
      // Standard JWT (We fetch the rest of the data in authenticateToken middleware)
      const token = jwt.sign({ id: user.rows[0].user_id }, process.env.JWT_SECRET || "secret", { expiresIn: "8h" });
      
      logAction(user.rows[0].user_id, 'LOGIN', 'Logged in', { headers: {}, socket: { remoteAddress: '::1' }, user: { region_id: user.rows[0].region_id } });
      res.json({ token }); 
    } catch(err) { res.status(500).send("Error"); }
});

// --- 6. SETTINGS & BRANDING (Admin Only) ---
// (Kept largely the same, but you might want to wrap this in requireRole(['SUPER_ADMIN']) later)
app.get("/api/settings", async (req, res) => {
  const result = await pool.query("SELECT * FROM system_settings WHERE id = 1");
  res.json(result.rows.length > 0 ? result.rows[0] : {});
});

const brandingUpload = upload.fields([{ name: 'logo', maxCount: 1 }, { name: 'loginBg', maxCount: 1 }]);

app.put("/api/settings", authenticateToken, brandingUpload, async (req, res) => {
    if(req.user.role !== 'SUPER_ADMIN') return res.status(403).json("Admins Only");
    
    try {
        const { systemName, orgName, primaryColor, welcomeMsg } = req.body;
        let logoUrl = req.files['logo'] ? `/uploads/${req.files['logo'][0].filename.replace(/\\/g, '/')}` : undefined;
        let loginBgUrl = req.files['loginBg'] ? `/uploads/${req.files['loginBg'][0].filename.replace(/\\/g, '/')}` : undefined;

        let query = "UPDATE system_settings SET system_name = $1, org_name = $2, primary_color = $3, welcome_msg = $4";
        let params = [systemName, orgName, primaryColor, welcomeMsg];
        let counter = 5;

        if (logoUrl) { query += `, logo_url = $${counter}`; params.push(logoUrl); counter++; }
        if (loginBgUrl) { query += `, login_bg_url = $${counter}`; params.push(loginBgUrl); counter++; }

        query += " WHERE id = 1 RETURNING *";
        const updated = await pool.query(query, params);
        res.json(updated.rows[0]);
    } catch (err) { res.status(500).send(err.message); }
});

// --- 7. BACKUP & RESTORE (Super Admin Only) ---
// (Logic retained, just enforced Role Check)
app.get("/api/backup", authenticateToken, (req, res) => {
    if(req.user.role !== 'SUPER_ADMIN') return res.status(403).json("Restricted Access");
    
    const pgPath = process.env.PG_PATH || "C:\\Program Files\\PostgreSQL\\16\\bin";
    const pgDump = path.join(pgPath, 'pg_dump.exe');
    if (!fs.existsSync(pgDump)) return res.status(500).json({ message: "pg_dump not found." });

    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    res.setHeader('Content-Type', 'application/sql');
    res.setHeader('Content-Disposition', `attachment; filename="backup_${timestamp}.sql"`);

    const dumpProcess = spawn(pgDump, ['-U', process.env.DB_USER, '-h', process.env.DB_HOST, '-p', process.env.DB_PORT, process.env.DB_DATABASE], {
        env: { ...process.env, PGPASSWORD: process.env.DB_PASSWORD } 
    });
    dumpProcess.stdout.pipe(res);
});

// START
app.listen(port, () => { console.log(`Server running on port ${port} [Enterprise Mode]`); });