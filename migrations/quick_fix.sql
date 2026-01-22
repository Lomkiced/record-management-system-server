-- FIXED Migration Script - Run this in pgAdmin
-- Handles existing tables without description column

-- 1. Add master password column
ALTER TABLE system_settings ADD COLUMN IF NOT EXISTS restricted_master_password VARCHAR(255);

-- 2. Add description column to offices if missing
ALTER TABLE offices ADD COLUMN IF NOT EXISTS description TEXT;

-- 3. Add office_id to records if missing
ALTER TABLE records ADD COLUMN IF NOT EXISTS office_id INTEGER;

-- 4. Insert default offices (without description to avoid column errors)
INSERT INTO offices (region_id, name, code)
SELECT r.id, 'Office of the Regional Director', 'ORD'
FROM regions r
WHERE NOT EXISTS (SELECT 1 FROM offices WHERE region_id = r.id AND code = 'ORD');

INSERT INTO offices (region_id, name, code)
SELECT r.id, 'Finance and Administrative Services', 'FAS'
FROM regions r
WHERE NOT EXISTS (SELECT 1 FROM offices WHERE region_id = r.id AND code = 'FAS');

INSERT INTO offices (region_id, name, code)
SELECT r.id, 'Information Technology Services Management', 'ITSM'
FROM regions r
WHERE NOT EXISTS (SELECT 1 FROM offices WHERE region_id = r.id AND code = 'ITSM');

INSERT INTO offices (region_id, name, code)
SELECT r.id, 'Field Operations Services', 'FOS'
FROM regions r
WHERE NOT EXISTS (SELECT 1 FROM offices WHERE region_id = r.id AND code = 'FOS');

INSERT INTO offices (region_id, name, code)
SELECT r.id, 'Regional Standards and Testing Laboratories', 'RSTL'
FROM regions r
WHERE NOT EXISTS (SELECT 1 FROM offices WHERE region_id = r.id AND code = 'RSTL');

INSERT INTO offices (region_id, name, code)
SELECT r.id, 'Science and Technology Scholarship', 'STS'
FROM regions r
WHERE NOT EXISTS (SELECT 1 FROM offices WHERE region_id = r.id AND code = 'STS');

-- Done! Verify:
SELECT * FROM offices;
SELECT restricted_master_password IS NOT NULL as has_password FROM system_settings WHERE id = 1;
