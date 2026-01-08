const pool = require("../config/db");

/**
 * INTELLIGENT AUDIT LOGGER
 * Automatically resolves User ID to Username and Region if missing from token.
 */
const logAudit = async (req, action, details) => {
  try {
    let userId = null;
    let username = "System / Guest";
    let regionId = null; // Default to NULL for guests/system

    // 1. Identify the User
    if (req.user && req.user.id) {
      userId = req.user.id;

      // Check if we have the info in the request object (fastest)
      if (req.user.username) username = req.user.username;
      if (req.user.region) regionId = req.user.region;

      // FALLBACK: If either Username OR Region is missing, fetch from DB
      if (!username || !regionId) {
        // Assuming 'id' is the primary key for your users table.
        // If your column is named 'user_id', change 'WHERE id =' to 'WHERE user_id ='
        const userRes = await pool.query(
          "SELECT username, region FROM users WHERE id = $1",
          [userId]
        );

        if (userRes.rows.length > 0) {
          // Only overwrite if we didn't have them already
          if (!req.user.username) username = userRes.rows[0].username;
          if (!req.user.region) regionId = userRes.rows[0].region;
        }
      }
    } else if (req.body && req.body.username) {
      // For login attempts (where token doesn't exist yet)
      username = req.body.username;
      // regionId remains null because we don't know it yet
    }

    // 2. Capture Environment
    const ip =
      req.headers["x-forwarded-for"] || req.socket.remoteAddress || "127.0.0.1";
    const userAgent = req.headers["user-agent"] || "Unknown Device";

    // 3. Record to Database (Updated with region_id)
    await pool.query(
      `INSERT INTO audit_logs (user_id, region_id, username, action, details, ip_address, user_agent)
             VALUES ($1, $2, $3, $4, $5, $6, $7)`,
      [userId, regionId, username, action, details, ip, userAgent]
    );

    console.log(
      `📝 [AUDIT RECORDED] ${username} (Region: ${
        regionId || "N/A"
      }) -> ${action}`
    );
  } catch (err) {
    // Silently fail so we don't crash the user's experience
    console.error("⚠️ Audit Log Error:", err.message);
  }
};

module.exports = { logAudit };
