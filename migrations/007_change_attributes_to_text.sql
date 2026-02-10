-- Add text columns for free input

ALTER TABLE records
ADD COLUMN IF NOT EXISTS media_text VARCHAR(255),
ADD COLUMN IF NOT EXISTS restriction_text VARCHAR(255),
ADD COLUMN IF NOT EXISTS frequency_text VARCHAR(255),
ADD COLUMN IF NOT EXISTS provision_text VARCHAR(255);

-- (Optional) Migrate existing data from lookup tables if we wanted to preserve it
-- UPDATE records r SET media_text = (SELECT name FROM record_media WHERE id = r.media_id);
-- UPDATE records r SET restriction_text = (SELECT name FROM record_restrictions WHERE id = r.restriction_id);
-- ... (skipping as data is fresh/test only likely)

-- Drop ID columns if cleaning up, or keep them but ignore them
-- For now, we will just start using the text columns.
