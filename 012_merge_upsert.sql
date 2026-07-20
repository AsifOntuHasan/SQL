-- ============================================================
-- 012: MERGE / UPSERT - insert or update based on existence
-- ============================================================

CREATE TABLE IF NOT EXISTS target_table (
    id      INT PRIMARY KEY,
    name    VARCHAR(50),
    value   VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS source_table (
    id      INT PRIMARY KEY,
    name    VARCHAR(50),
    value   VARCHAR(100)
);

INSERT INTO target_table VALUES (1, 'Alice', 'old_value'), (2, 'Bob', 'data');
INSERT INTO source_table VALUES (1, 'Alice', 'new_value'), (3, 'Charlie', 'new_data');

-- SQL Server / PostgreSQL: MERGE
-- PostgreSQL syntax:
/*
MERGE INTO target_table AS t
USING source_table AS s ON t.id = s.id
WHEN MATCHED THEN
    UPDATE SET name = s.name, value = s.value
WHEN NOT MATCHED THEN
    INSERT (id, name, value) VALUES (s.id, s.name, s.value);
*/

-- SQL Server syntax:
/*
MERGE target_table AS t
USING source_table AS s ON t.id = s.id
WHEN MATCHED THEN
    UPDATE SET t.name = s.name, t.value = s.value
WHEN NOT MATCHED THEN
    INSERT (id, name, value) VALUES (s.id, s.name, s.value);
*/

-- MySQL: INSERT ... ON DUPLICATE KEY UPDATE
/*
INSERT INTO target_table (id, name, value)
SELECT id, name, value FROM source_table
ON DUPLICATE KEY UPDATE name = VALUES(name), value = VALUES(value);
*/

-- SQLite: INSERT OR REPLACE or ON CONFLICT
/*
INSERT OR REPLACE INTO target_table (id, name, value)
SELECT id, name, value FROM source_table;
*/
-- or
/*
INSERT INTO target_table (id, name, value)
SELECT id, name, value FROM source_table
ON CONFLICT(id) DO UPDATE SET name = EXCLUDED.name, value = EXCLUDED.value;
*/

-- PostgreSQL: ON CONFLICT (alternative to MERGE)
/*
INSERT INTO target_table (id, name, value)
SELECT id, name, value FROM source_table
ON CONFLICT (id) DO UPDATE
SET name = EXCLUDED.name, value = EXCLUDED.value;
*/

-- Simulated merge using CTE (works across databases)
WITH upsert AS (
    SELECT s.id, s.name, s.value
    FROM source_table s
    LEFT JOIN target_table t ON s.id = t.id
)
-- For demonstration: update existing, then insert new
UPDATE target_table t
SET name = s.name, value = s.value
FROM source_table s
WHERE t.id = s.id;

INSERT INTO target_table (id, name, value)
SELECT s.id, s.name, s.value
FROM source_table s
WHERE NOT EXISTS (SELECT 1 FROM target_table t WHERE t.id = s.id);

-- Verify
SELECT * FROM target_table ORDER BY id;

-- Cleanup
DROP TABLE IF EXISTS source_table;
DROP TABLE IF EXISTS target_table;
