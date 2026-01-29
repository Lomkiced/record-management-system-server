-- =====================================================
-- DOST-RMS Database Initialization Script
-- Run this in the Docker PostgreSQL container
-- =====================================================

-- Create user role enum
DO $$ BEGIN
    CREATE TYPE public.user_role AS ENUM ('SUPER_ADMIN', 'REGIONAL_ADMIN', 'STAFF');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- =====================================================
-- TABLES
-- =====================================================

-- Regions table
CREATE TABLE IF NOT EXISTS public.regions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE,
    address VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Active'
);

-- Offices table
CREATE TABLE IF NOT EXISTS public.offices (
    office_id SERIAL PRIMARY KEY,
    region_id INTEGER REFERENCES public.regions(id),
    name VARCHAR(150) NOT NULL,
    code VARCHAR(20),
    description TEXT,
    status VARCHAR(50) DEFAULT 'Active'
);

-- Users table
CREATE TABLE IF NOT EXISTS public.users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    region_id INTEGER REFERENCES public.regions(id),
    office VARCHAR(100),
    office_id INTEGER REFERENCES public.offices(office_id),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    full_name VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(255)
);

-- Audit logs table
CREATE TABLE IF NOT EXISTS public.audit_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    username VARCHAR(100),
    action VARCHAR(50) NOT NULL,
    details TEXT,
    ip_address VARCHAR(50),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    region_id INTEGER REFERENCES public.regions(id)
);

-- Codex categories table
CREATE TABLE IF NOT EXISTS public.codex_categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    region VARCHAR(50) DEFAULT 'Global',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Codex types table
CREATE TABLE IF NOT EXISTS public.codex_types (
    type_id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES public.codex_categories(category_id) ON DELETE CASCADE,
    type_name VARCHAR(150) NOT NULL,
    retention_period VARCHAR(50),
    region VARCHAR(50) DEFAULT 'Global',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Record categories table
CREATE TABLE IF NOT EXISTS public.record_categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT
);

-- Record types table
CREATE TABLE IF NOT EXISTS public.record_types (
    type_id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES public.record_categories(category_id) ON DELETE CASCADE,
    type_name VARCHAR(255) NOT NULL,
    retention_period VARCHAR(100) DEFAULT '5 Years',
    description TEXT
);

-- Records table
CREATE TABLE IF NOT EXISTS public.records (
    record_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    region_id INTEGER REFERENCES public.regions(id),
    category VARCHAR(100),
    classification_rule VARCHAR(255),
    file_path VARCHAR(255),
    file_size BIGINT,
    file_type VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Active',
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uploaded_by INTEGER REFERENCES public.users(user_id) ON DELETE SET NULL,
    retention_period VARCHAR(50),
    disposal_date DATE,
    is_restricted BOOLEAN DEFAULT FALSE,
    file_password VARCHAR(255),
    office_id INTEGER REFERENCES public.offices(office_id),
    shelf VARCHAR(100)
);

-- System settings table
CREATE TABLE IF NOT EXISTS public.system_settings (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    system_name VARCHAR(100) DEFAULT 'DOST-RMS',
    org_name VARCHAR(150) DEFAULT 'Department of Science and Technology',
    welcome_msg TEXT DEFAULT 'Sign in to access the system.',
    primary_color VARCHAR(50) DEFAULT '#4f46e5',
    secondary_color VARCHAR(50) DEFAULT '#0f172a',
    logo_url TEXT,
    login_bg_url TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    restricted_master_password VARCHAR(255)
);

-- =====================================================
-- INDEXES
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_audit_action ON public.audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_date ON public.audit_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_audit_region ON public.audit_logs(region_id);
CREATE INDEX IF NOT EXISTS idx_audit_user ON public.audit_logs(username);

-- =====================================================
-- SEED DATA
-- =====================================================

-- Insert default system settings
INSERT INTO public.system_settings (id, system_name, org_name, welcome_msg, primary_color, secondary_color)
VALUES (1, 'DOST-RMS', 'Department of Science and Technology', 'Sign in to access the Record Management System.', '#6b42ff', '#9497ff')
ON CONFLICT (id) DO NOTHING;

-- Insert default regions
INSERT INTO public.regions (name, code, address, status) VALUES
    ('Central Office', 'CO', NULL, 'Active'),
    ('National Capital Region', 'NCR', NULL, 'Active'),
    ('Cordillera Administrative Region', 'CAR', NULL, 'Active'),
    ('Region I - Ilocos', 'R1', NULL, 'Active'),
    ('Region II - Cagayan Valley', 'R2', NULL, 'Active'),
    ('Region III - Central Luzon', 'R3', NULL, 'Active'),
    ('La Union', 'R1.1', 'SFC, La Union', 'Active')
ON CONFLICT (code) DO NOTHING;

-- Insert default codex categories
INSERT INTO public.codex_categories (name, region) VALUES
    ('Administrative and Management Records', 'Global'),
    ('Budget Records', 'Global'),
    ('Financial and Accounting Records', 'Global'),
    ('Human Resource/Personnel Management Records', 'Global')
ON CONFLICT (name) DO NOTHING;

-- Insert default record categories
INSERT INTO public.record_categories (name, description) VALUES
    ('Administrative and Management Records', NULL),
    ('Budget Records', NULL),
    ('Financial and Accounting Records', NULL),
    ('Human Resource/Personnel Management Records', NULL),
    ('Information Technology Records', NULL),
    ('Legal Records', NULL),
    ('Procurement and Supply Records', NULL),
    ('Training Records', NULL)
ON CONFLICT (name) DO NOTHING;

-- Create default Super Admin user (password: admin123)
-- The bcrypt hash is for 'admin123'
INSERT INTO public.users (username, password, role, region_id, office, status, name)
SELECT 'admin', '$2b$10$rOzJqQZQZ6G5GZq4iKfQauqBnReJXJ3S.KPMbPOSp6gVIJd.yMWxu', 'SUPER_ADMIN', NULL, 'ITSM', 'Active', 'System Administrator'
WHERE NOT EXISTS (SELECT 1 FROM public.users WHERE username = 'admin');

-- Log initialization
INSERT INTO public.audit_logs (username, action, details, ip_address)
VALUES ('System', 'SYSTEM_INIT', 'Database initialized via Docker', '127.0.0.1');

SELECT 'Database initialization complete!' as status;
