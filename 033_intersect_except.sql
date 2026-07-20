-- ============================================================
-- 033: INTERSECT & EXCEPT / MINUS - set comparison operators
-- ============================================================

CREATE TABLE IF NOT EXISTS dataset_a (
    id   INT PRIMARY KEY,
    val  VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dataset_b (
    id   INT PRIMARY KEY,
    val  VARCHAR(50)
);

INSERT INTO dataset_a VALUES (1, 'A1'), (2, 'A2'), (3, 'A3'), (4, 'A4');
INSERT INTO dataset_b VALUES (3, 'A3'), (4, 'A4'), (5, 'B5'), (6, 'B6');

-- INTERSECT: rows present in both result sets
-- PostgreSQL, SQL Server, SQLite (v3.29+)
SELECT id, val FROM dataset_a
INTERSECT
SELECT id, val FROM dataset_b
ORDER BY id;

-- EXCEPT (PostgreSQL, SQL Server, SQLite)
-- Rows in dataset_a but not in dataset_b
SELECT id, val FROM dataset_a
EXCEPT
SELECT id, val FROM dataset_b
ORDER BY id;

-- MINUS (Oracle equivalent of EXCEPT)
-- SELECT id, val FROM dataset_a
-- MINUS
-- SELECT id, val FROM dataset_b;

-- EXCEPT ALL (PostgreSQL only - keeps duplicates)
-- SELECT id, val FROM dataset_a
-- EXCEPT ALL
-- SELECT id, val FROM dataset_b;

-- Simulating INTERSECT using IN
SELECT a.id, a.val
FROM dataset_a a
WHERE (a.id, a.val) IN (SELECT b.id, b.val FROM dataset_b b)
ORDER BY a.id;

-- Simulating EXCEPT using NOT EXISTS
SELECT a.id, a.val
FROM dataset_a a
WHERE NOT EXISTS (
    SELECT 1 FROM dataset_b b
    WHERE b.id = a.id AND b.val = a.val
)
ORDER BY a.id;

-- Simulating INTERSECT using JOIN
SELECT DISTINCT a.id, a.val
FROM dataset_a a
JOIN dataset_b b ON a.id = b.id AND a.val = b.val
ORDER BY a.id;

-- Cleanup
DROP TABLE IF EXISTS dataset_a;
DROP TABLE IF EXISTS dataset_b;
