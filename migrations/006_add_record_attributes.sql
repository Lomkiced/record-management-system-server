-- 1. Create Lookup Tables

CREATE TABLE IF NOT EXISTS record_media (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS record_restrictions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS record_frequencies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS disposition_provisions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- 2. Seed Initial Data

INSERT INTO record_media (name) VALUES 
('Paper'), 
('Electronic'), 
('Microfilm'), 
('Audio/Visual') 
ON CONFLICT (name) DO NOTHING;

INSERT INTO record_restrictions (name) VALUES 
('Open Access'), 
('Restricted'), 
('Confidential'), 
('Secret'),
('Top Secret')
ON CONFLICT (name) DO NOTHING;

INSERT INTO record_frequencies (name) VALUES 
('Daily'), 
('Weekly'), 
('Monthly'), 
('Quarterly'), 
('Annually'), 
('Rarely') 
ON CONFLICT (name) DO NOTHING;

INSERT INTO disposition_provisions (name) VALUES 
('NAP Circular No. 1'), 
('NAP Circular No. 2'), 
('Agency Records Disposition Schedule (RDS)'), 
('General Records Disposition Schedule (GRDS)') 
ON CONFLICT (name) DO NOTHING;

-- 3. Add Columns to Records Table

ALTER TABLE records 
ADD COLUMN IF NOT EXISTS media_id INTEGER REFERENCES record_media(id),
ADD COLUMN IF NOT EXISTS restriction_id INTEGER REFERENCES record_restrictions(id),
ADD COLUMN IF NOT EXISTS frequency_id INTEGER REFERENCES record_frequencies(id),
ADD COLUMN IF NOT EXISTS provision_id INTEGER REFERENCES disposition_provisions(id);

-- Optional: Create indexes for performance if needed
CREATE INDEX IF NOT EXISTS idx_records_media ON records(media_id);
CREATE INDEX IF NOT EXISTS idx_records_restriction ON records(restriction_id);
