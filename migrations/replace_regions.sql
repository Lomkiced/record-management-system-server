-- Replace Regions with Region 1 Provinces
-- WARNING: This will delete existing region data and reassign records/users to new regions

BEGIN;

-- Step 1: Handle audit_logs references (set to NULL to avoid foreign key constraint)
UPDATE audit_logs SET region_id = NULL WHERE region_id IS NOT NULL;

-- Step 2: Temporarily reassign records/users to region_id 1
UPDATE records SET region_id = 1 WHERE region_id IS NOT NULL;
UPDATE users SET region_id = 1 WHERE region_id IS NOT NULL;

-- Step 3: Delete all existing regions (now safe because no foreign keys reference them)
DELETE FROM regions;

-- Step 4: Reset the sequence
ALTER SEQUENCE regions_id_seq RESTART WITH 1;

-- Step 5: Insert Region 1 (Ilocos Region) provinces
INSERT INTO regions (name, code, address, status) VALUES
  ('Ilocos Norte', 'IN', 'DOST Provincial Office, San Nicolas, Ilocos Norte', 'Active'),
  ('Ilocos Sur', 'IS', 'DOST Provincial Office, Vigan City, Ilocos Sur', 'Active'),
  ('La Union', 'LU', 'DOST Regional Office, San Fernando City, La Union', 'Active'),
  ('Pangasinan', 'PG', 'DOST Provincial Office, Lingayen, Pangasinan', 'Active');

-- Step 6: Delete existing offices (they reference old regions)
DELETE FROM offices;

-- Step 7: Create offices for each new province
INSERT INTO offices (region_id, name, code, description) VALUES
  -- Ilocos Norte (region_id = 1)
  (1, 'Office of the Regional Director', 'ORD', 'Executive office handling policy and oversight'),
  (1, 'Finance and Administrative Services', 'FAS', 'Budget, accounting, and administrative operations'),
  (1, 'Information Technology Services Management', 'ITSM', 'IT infrastructure and digital services'),
  (1, 'Field Operations Services', 'FOS', 'Field implementation and community programs'),
  (1, 'Regional Standards and Testing Laboratories', 'RSTL', 'Testing, calibration, and metrology services'),
  (1, 'Science and Technology Scholarship', 'STS', 'Scholarship programs and human resource development'),
  
  -- Ilocos Sur (region_id = 2)
  (2, 'Office of the Regional Director', 'ORD', 'Executive office handling policy and oversight'),
  (2, 'Finance and Administrative Services', 'FAS', 'Budget, accounting, and administrative operations'),
  (2, 'Information Technology Services Management', 'ITSM', 'IT infrastructure and digital services'),
  (2, 'Field Operations Services', 'FOS', 'Field implementation and community programs'),
  (2, 'Regional Standards and Testing Laboratories', 'RSTL', 'Testing, calibration, and metrology services'),
  (2, 'Science and Technology Scholarship', 'STS', 'Scholarship programs and human resource development'),
  
  -- La Union (region_id = 3)
  (3, 'Office of the Regional Director', 'ORD', 'Executive office handling policy and oversight'),
  (3, 'Finance and Administrative Services', 'FAS', 'Budget, accounting, and administrative operations'),
  (3, 'Information Technology Services Management', 'ITSM', 'IT infrastructure and digital services'),
  (3, 'Field Operations Services', 'FOS', 'Field implementation and community programs'),
  (3, 'Regional Standards and Testing Laboratories', 'RSTL', 'Testing, calibration, and metrology services'),
  (3, 'Science and Technology Scholarship', 'STS', 'Scholarship programs and human resource development'),
  
  -- Pangasinan (region_id = 4)
  (4, 'Office of the Regional Director', 'ORD', 'Executive office handling policy and oversight'),
  (4, 'Finance and Administrative Services', 'FAS', 'Budget, accounting, and administrative operations'),
  (4, 'Information Technology Services Management', 'ITSM', 'IT infrastructure and digital services'),
  (4, 'Field Operations Services', 'FOS', 'Field implementation and community programs'),
  (4, 'Regional Standards and Testing Laboratories', 'RSTL', 'Testing, calibration, and metrology services'),
  (4, 'Science and Technology Scholarship', 'STS', 'Scholarship programs and human resource development');

-- Step 8: Update Super Admin user to have access to all regions (region_id can be NULL for SUPER_ADMIN)
UPDATE users SET region_id = NULL WHERE role = 'SUPER_ADMIN';

COMMIT;

-- Verify the changes
SELECT 'Regions:' as info;
SELECT * FROM regions ORDER BY id;

SELECT 'Offices per region:' as info;
SELECT r.name as province, COUNT(o.office_id) as office_count 
FROM regions r 
LEFT JOIN offices o ON r.id = o.region_id 
GROUP BY r.id, r.name 
ORDER BY r.id;

SELECT 'Records count:' as info;
SELECT COUNT(*) as total_records FROM records;

SELECT 'Users count:' as info;
SELECT COUNT(*) as total_users FROM users;
