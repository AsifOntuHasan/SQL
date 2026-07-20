-- ============================================================
-- 003: DROP TABLE & TRUNCATE TABLE - cleanup operations
-- Difference: DROP removes schema+data; TRUNCATE removes data only
-- ============================================================

CREATE TABLE IF NOT EXISTS temp_data (
    id      INT PRIMARY KEY,
    value   VARCHAR(50)
);

INSERT INTO temp_data VALUES (1, 'A'), (2, 'B'), (3, 'C');

-- TRUNCATE: removes all rows, keeps table structure
TRUNCATE TABLE temp_data;

-- Verify table still exists but is empty
SELECT * FROM temp_data;

-- DROP TABLE: removes table entirely
DROP TABLE IF EXISTS temp_data;

-- CASCADE drops dependent objects (PostgreSQL)
-- DROP TABLE IF EXISTS parent CASCADE;

-- RESTRICT prevents drop if dependencies exist (default in some DBs)
-- DROP TABLE IF EXISTS parent RESTRICT;

-- Temporary table example (dropped automatically at session end)
CREATE TEMP TABLE IF NOT EXISTS session_cache AS
SELECT 1 AS id, 'cache' AS info;

DROP TABLE IF EXISTS session_cache;

-- IF EXISTS prevents error when table doesn't exist
DROP TABLE IF EXISTS nonexistent_table;
