-- =====================================================
-- DOST-RMS Database Migration Script
-- Enhancement: Region 1 Provinces, Office Hierarchy, Master Password
-- Date: 2026-01-18
-- =====================================================

-- STEP 1: Update Regions to Region 1 Provinces Only
-- =====================================================
-- First, we need to handle foreign key constraints
-- This will delete all existing region data and replace with Region 1 provinces

-- Temporarily disable foreign key checks by deleting dependent data first
DELETE FROM records WHERE region_id NOT IN (SELECT id FROM regions WHERE 1=0);
DELETE FROM users WHERE region_id IS NOT NULL;

-- Clear and repopulate regions with Region 1 provinces
DELETE FROM regions;

-- Reset the sequence
ALTER SEQUENCE regions_id_seq RESTART WITH 1;

-- Insert Region 1 (Ilocos Region) provinces
INSERT INTO regions (name, code, address, status) VALUES
  ('Ilocos Norte', 'IN', 'DOST Provincial Office, San Nicolas, Ilocos Norte', 'Active'),
  ('Ilocos Sur', 'IS', 'DOST Provincial Office, Vigan City, Ilocos Sur', 'Active'),
  ('La Union', 'LU', 'DOST Regional Office, San Fernando City, La Union', 'Active'),
  ('Pangasinan', 'PG', 'DOST Provincial Office, Lingayen, Pangasinan', 'Active');

-- =====================================================
-- STEP 2: Create Offices Table (Province -> Office Hierarchy)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.offices (
    office_id SERIAL PRIMARY KEY,
    region_id INTEGER REFERENCES regions(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_offices_region ON offices(region_id);

-- Seed default DOST offices for all provinces
INSERT INTO offices (region_id, name, code, description)
SELECT id, 'Office of the Regional Director', 'ORD', 'Executive office handling policy and oversight'
FROM regions;

INSERT INTO offices (region_id, name, code, description)
SELECT id, 'Finance and Administrative Services', 'FAS', 'Budget, accounting, and administrative operations'
FROM regions;

INSERT INTO offices (region_id, name, code, description)
SELECT id, 'Information Technology Services Management', 'ITSM', 'IT infrastructure and digital services'
FROM regions;

INSERT INTO offices (region_id, name, code, description)
SELECT id, 'Field Operations Services', 'FOS', 'Field implementation and community programs'
FROM regions;

INSERT INTO offices (region_id, name, code, description)
SELECT id, 'Regional Standards and Testing Laboratories', 'RSTL', 'Testing, calibration, and metrology services'
FROM regions;

INSERT INTO offices (region_id, name, code, description)
SELECT id, 'Science and Technology Scholarship', 'STS', 'Scholarship programs and human resource development'
FROM regions;

-- =====================================================
-- STEP 3: Add office_id to Records Table
-- =====================================================
ALTER TABLE records ADD COLUMN IF NOT EXISTS office_id INTEGER REFERENCES offices(office_id);

-- Create index for faster filtering
CREATE INDEX IF NOT EXISTS idx_records_office ON records(office_id);

-- =====================================================
-- STEP 4: Add Master Password to System Settings
-- =====================================================
ALTER TABLE system_settings ADD COLUMN IF NOT EXISTS restricted_master_password VARCHAR(255);

-- =====================================================
-- STEP 5: Verify Migration
-- =====================================================
-- Run these queries to verify the migration was successful:
-- SELECT * FROM regions;
-- SELECT o.*, r.name as province FROM offices o JOIN regions r ON o.region_id = r.id ORDER BY r.name, o.name;
-- SELECT restricted_master_password FROM system_settings WHERE id = 1;

-- =====================================================
-- END OF MIGRATION
-- =====================================================
