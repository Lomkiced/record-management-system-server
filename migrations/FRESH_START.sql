-- =====================================================
-- FRESH START MIGRATION - Region 1 Provinces Only
-- User authorized: Deletes ALL existing data
-- =====================================================

-- First, run this to rollback any failed transaction:
-- ROLLBACK;

-- Then run this script:
BEGIN;

-- =====================================================
-- STEP 1: CLEAN SLATE - Delete all dependent data
-- =====================================================
TRUNCATE TABLE audit_logs CASCADE;
TRUNCATE TABLE records CASCADE;
TRUNCATE TABLE offices CASCADE;

-- Set all users' region_id to NULL (keep all users, just remove region assignment)
UPDATE users SET region_id = NULL;

-- Now safe to delete all regions
DELETE FROM regions CASCADE;

-- =====================================================
-- STEP 2: Add required columns if missing
-- =====================================================
ALTER TABLE system_settings ADD COLUMN IF NOT EXISTS restricted_master_password VARCHAR(255);
ALTER TABLE records ADD COLUMN IF NOT EXISTS office_id INTEGER;
ALTER TABLE offices ADD COLUMN IF NOT EXISTS description TEXT;

-- =====================================================
-- STEP 3: Reset sequences
-- =====================================================
ALTER SEQUENCE regions_id_seq RESTART WITH 1;
ALTER SEQUENCE offices_office_id_seq RESTART WITH 1;

-- =====================================================
-- STEP 4: Insert Region 1 (Ilocos Region) Provinces
-- =====================================================
INSERT INTO regions (name, code, address, status) VALUES
  ('Ilocos Norte', 'IN', 'DOST Provincial Office, San Nicolas, Ilocos Norte', 'Active'),
  ('Ilocos Sur', 'IS', 'DOST Provincial Office, Vigan City, Ilocos Sur', 'Active'),
  ('La Union', 'LU', 'DOST Regional Office, San Fernando City, La Union', 'Active'),
  ('Pangasinan', 'PG', 'DOST Provincial Office, Lingayen, Pangasinan', 'Active');

-- =====================================================
-- STEP 5: Create Offices for Each Province
-- =====================================================
INSERT INTO offices (region_id, name, code, description, status) VALUES
  -- Ilocos Norte (region_id = 1)
  (1, 'Office of the Regional Director', 'ORD', 'Executive office handling policy and oversight', 'Active'),
  (1, 'Finance and Administrative Services', 'FAS', 'Budget, accounting, and administrative operations', 'Active'),
  (1, 'Information Technology Services Management', 'ITSM', 'IT infrastructure and digital services', 'Active'),
  (1, 'Field Operations Services', 'FOS', 'Field implementation and community programs', 'Active'),
  (1, 'Regional Standards and Testing Laboratories', 'RSTL', 'Testing, calibration, and metrology services', 'Active'),
  (1, 'Science and Technology Scholarship', 'STS', 'Scholarship programs and human resource development', 'Active'),
  
  -- Ilocos Sur (region_id = 2)
  (2, 'Office of the Regional Director', 'ORD', 'Executive office handling policy and oversight', 'Active'),
  (2, 'Finance and Administrative Services', 'FAS', 'Budget, accounting, and administrative operations', 'Active'),
  (2, 'Information Technology Services Management', 'ITSM', 'IT infrastructure and digital services', 'Active'),
  (2, 'Field Operations Services', 'FOS', 'Field implementation and community programs', 'Active'),
  (2, 'Regional Standards and Testing Laboratories', 'RSTL', 'Testing, calibration, and metrology services', 'Active'),
  (2, 'Science and Technology Scholarship', 'STS', 'Scholarship programs and human resource development', 'Active'),
  
  -- La Union (region_id = 3)
  (3, 'Office of the Regional Director', 'ORD', 'Executive office handling policy and oversight', 'Active'),
  (3, 'Finance and Administrative Services', 'FAS', 'Budget, accounting, and administrative operations', 'Active'),
  (3, 'Information Technology Services Management', 'ITSM', 'IT infrastructure and digital services', 'Active'),
  (3, 'Field Operations Services', 'FOS', 'Field implementation and community programs', 'Active'),
  (3, 'Regional Standards and Testing Laboratories', 'RSTL', 'Testing, calibration, and metrology services', 'Active'),
  (3, 'Science and Technology Scholarship', 'STS', 'Scholarship programs and human resource development', 'Active'),
  
  -- Pangasinan (region_id = 4)
  (4, 'Office of the Regional Director', 'ORD', 'Executive office handling policy and oversight', 'Active'),
  (4, 'Finance and Administrative Services', 'FAS', 'Budget, accounting, and administrative operations', 'Active'),
  (4, 'Information Technology Services Management', 'ITSM', 'IT infrastructure and digital services', 'Active'),
  (4, 'Field Operations Services', 'FOS', 'Field implementation and community programs', 'Active'),
  (4, 'Regional Standards and Testing Laboratories', 'RSTL', 'Testing, calibration, and metrology services', 'Active'),
  (4, 'Science and Technology Scholarship', 'STS', 'Scholarship programs and human resource development', 'Active');

-- =====================================================
-- STEP 6: Ensure Super Admin has no region restriction
-- =====================================================
UPDATE users SET region_id = NULL WHERE role = 'SUPER_ADMIN';

COMMIT;

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================
SELECT 'SUCCESS! Migration Complete' as status;

SELECT 'Total Regions:' as info, COUNT(*) as count FROM regions;
SELECT * FROM regions ORDER BY id;

SELECT 'Total Offices:' as info, COUNT(*) as count FROM offices;
SELECT r.name as province, COUNT(o.office_id) as office_count 
FROM regions r 
LEFT JOIN offices o ON r.id = o.region_id 
GROUP BY r.id, r.name 
ORDER BY r.id;

SELECT 'Master Password Configured:' as info, 
       CASE WHEN restricted_master_password IS NULL THEN 'NO - Set in System Branding' ELSE 'YES' END as status 
FROM system_settings WHERE id = 1;
