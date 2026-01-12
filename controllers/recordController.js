const pool = require('../config/db');
const fs = require('fs');
const path = require('path');
const bcrypt = require('bcryptjs'); // Required for password hashing
const { logAudit } = require('../utils/auditLogger');

// Helper: Calculate Date
const calculateDisposalDate = (period) => {
    if (!period || typeof period !== 'string') return null;
    const cleanPeriod = period.toLowerCase().trim();
    if (cleanPeriod.includes('permanent')) return null;
    
    const match = cleanPeriod.match(/(\d+)/);
    if (!match) return null;
    
    const years = parseInt(match[0], 10);
    const date = new Date();
    date.setFullYear(date.getFullYear() + years);
    return date.toISOString().split('T')[0];
};

const parseId = (id) => (id === undefined || id === null || id === '') ? null : parseInt(id, 10);

// 1. UPLOAD RECORD (With Security)
exports.createRecord = async (req, res) => {
    try {
        console.log(`[UPLOAD] User: ${req.user.username}`);
        
        const { title, region_id, category_name, classification_rule, retention_period, is_restricted, file_password } = req.body;
        
        // Resolve Region
        let targetRegion = null;
        if (req.user.role === 'SUPER_ADMIN') {
            targetRegion = parseId(region_id);
        } else {
            const userCheck = await pool.query("SELECT region_id FROM users WHERE user_id = $1", [req.user.id]);
            targetRegion = userCheck.rows[0]?.region_id;
        }

        if (!targetRegion && req.user.role !== 'SUPER_ADMIN') {
            return res.status(400).json({ message: "No assigned region." });
        }

        if (!req.file) return res.status(400).json({ message: "No file uploaded." });

        // --- SECURITY HANDLING ---
        const restricted = is_restricted === 'true'; // FormData sends boolean as string
        let hashedPassword = null;
        
        if (restricted) {
            if (!file_password) return res.status(400).json({ message: "Password required for restricted files." });
            hashedPassword = await bcrypt.hash(file_password, 10); // Encrypt password
        }

        const disposalDate = calculateDisposalDate(retention_period);

        const sql = `
            INSERT INTO records 
            (title, region_id, category, classification_rule, retention_period, disposal_date, file_path, file_size, file_type, status, uploaded_by, is_restricted, file_password) 
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
            RETURNING record_id
        `;

        const values = [
            title, targetRegion, category_name, classification_rule, retention_period, 
            disposalDate, req.file.filename, req.file.size, req.file.mimetype, 
            'Active', req.user.id,
            restricted, hashedPassword
        ];

        const { rows } = await pool.query(sql, values);
        
        await logAudit(req, 'UPLOAD_RECORD', `Uploaded "${title}" (Restricted: ${restricted})`);
        res.status(201).json({ message: "Saved", record_id: rows[0].record_id });

    } catch (error) {
        console.error("Upload Failed:", error.message);
        res.status(500).json({ message: "Db Error", error: error.message });
    }
};

// 2. GET RECORDS (Excludes Password from Response)
exports.getRecords = async (req, res) => {
    try {
        const { page = 1, limit = 10, search = '', category, status, region } = req.query;
        const offset = (page - 1) * limit;

        let userRegionId = req.user.region_id;
        if (req.user.role !== 'SUPER_ADMIN') {
             const userCheck = await pool.query("SELECT region_id FROM users WHERE user_id = $1", [req.user.id]);
             userRegionId = userCheck.rows[0]?.region_id;
        }

        // We SELECT specific fields to avoid sending the password hash to the frontend
        let query = `
            SELECT r.record_id, r.title, r.region_id, r.category, r.classification_rule, 
                   r.retention_period, r.disposal_date, r.file_path, r.file_size, r.file_type, 
                   r.status, r.uploaded_at, r.is_restricted, 
                   reg.name as region_name, u.username as uploader_name
            FROM records r
            LEFT JOIN regions reg ON r.region_id = reg.id
            LEFT JOIN users u ON r.uploaded_by = u.user_id
            WHERE 1=1
        `;
        let params = [];
        let counter = 1;

        if (req.user.role !== 'SUPER_ADMIN') {
            query += ` AND r.region_id = $${counter++}`;
            params.push(userRegionId);
        } else if (region && region !== 'All') {
            query += ` AND r.region_id = $${counter++}`;
            params.push(parseId(region));
        }

        if (status && status !== 'All') { query += ` AND r.status = $${counter++}`; params.push(status); }
        if (category && category !== 'All') { query += ` AND r.category = $${counter++}`; params.push(category); }
        if (search) { query += ` AND r.title ILIKE $${counter++}`; params.push(`%${search}%`); }

        query += ` ORDER BY r.uploaded_at DESC LIMIT $${counter++} OFFSET $${counter++}`;
        params.push(limit, offset);

        const { rows } = await pool.query(query, params);
        res.json({ data: rows });

    } catch (err) {
        console.error("Fetch Error:", err.message);
        res.status(500).json({ message: "Server Error" });
    }
};

// 3. VERIFY PASSWORD (New Endpoint)
exports.verifyRecordAccess = async (req, res) => {
    try {
        const { id } = req.params;
        const { password } = req.body;

        const result = await pool.query("SELECT file_password, is_restricted FROM records WHERE record_id = $1", [id]);
        
        if (result.rows.length === 0) return res.status(404).json({ message: "File not found" });
        
        const record = result.rows[0];

        // If not restricted, allow
        if (!record.is_restricted) return res.json({ success: true });

        // Check password
        const isMatch = await bcrypt.compare(password, record.file_password);
        
        if (!isMatch) {
            await logAudit(req, 'ACCESS_DENIED', `Failed password attempt for Record ID: ${id}`);
            return res.status(401).json({ success: false, message: "Incorrect Password" });
        }

        await logAudit(req, 'ACCESS_GRANTED', `Unlocked restricted Record ID: ${id}`);
        res.json({ success: true });

    } catch (err) {
        console.error("Verification Error:", err);
        res.status(500).json({ message: "Server Error" });
    }
};

// ... (Existing delete/archive/restore exports remain unchanged) ...
exports.deleteRecord = async (req, res) => { /* keep existing */ };
exports.archiveRecord = async (req, res) => { /* keep existing */ };
exports.restoreRecord = async (req, res) => { /* keep existing */ };
exports.updateRecord = async (req, res) => { /* keep existing */ };