// server/controllers/profileController.js
const pool = require('../config/db'); // ⚠️ Check this path matches your database connection file
const bcrypt = require('bcrypt');

// GET /api/profile
const getProfile = async (req, res) => {
  try {
    // req.user.id comes from the 'authenticateToken' middleware
    const userId = req.user.id; 

    const result = await pool.query(
      'SELECT id, full_name, email, phone, role, office, location, bio, avatar_url FROM users WHERE id = $1',
      [userId]
    );

    if (result.rows.length === 0) return res.status(404).json({ message: 'User not found' });

    const user = result.rows[0];

    // Send back data in the format the Frontend expects (camelCase)
    res.json({
      fullName: user.full_name,
      email: user.email,
      phone: user.phone || '',
      department: user.office || '', 
      role: user.role,
      location: user.location || '',
      bio: user.bio || '',
      avatarUrl: user.avatar_url || null
    });

  } catch (err) {
    console.error("Error fetching profile:", err.message);
    res.status(500).send('Server Error');
  }
};

// PUT /api/profile
const updateProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    // Destructure the fields sent from UserProfile.jsx
    const { fullName, email, phone, department, location, bio } = req.body;

    // Update query
    await pool.query(
      `UPDATE users 
       SET full_name = $1, email = $2, phone = $3, office = $4, location = $5, bio = $6
       WHERE id = $7`,
      [fullName, email, phone, department, location, bio, userId]
    );

    res.json({ message: 'Profile updated successfully' });

  } catch (err) {
    console.error("Error updating profile:", err.message);
    res.status(500).send('Server Error');
  }
};

// PUT /api/profile/password
const updatePassword = async (req, res) => {
  try {
    const userId = req.user.id;
    const { currentPassword, newPassword } = req.body;

    // 1. Get current hash
    const userResult = await pool.query('SELECT password FROM users WHERE id = $1', [userId]);
    if (userResult.rows.length === 0) return res.status(404).json({ message: 'User not found' });

    // 2. Verify current password
    const validPassword = await bcrypt.compare(currentPassword, userResult.rows[0].password);
    if (!validPassword) {
      return res.status(400).json({ message: 'Incorrect current password' });
    }

    // 3. Hash new password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(newPassword, salt);

    // 4. Save
    await pool.query('UPDATE users SET password = $1 WHERE id = $2', [hashedPassword, userId]);

    res.json({ message: 'Password updated successfully' });

  } catch (err) {
    console.error("Error updating password:", err.message);
    res.status(500).send('Server Error');
  }
};

module.exports = { getProfile, updateProfile, updatePassword }; 