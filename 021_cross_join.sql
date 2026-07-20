-- ============================================================
-- 021: CROSS JOIN - Cartesian product of two tables
-- ============================================================

CREATE TABLE IF NOT EXISTS sizes (
    size_id   INT PRIMARY KEY,
    size_name VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS colors (
    color_id   INT PRIMARY KEY,
    color_name VARCHAR(20)
);

INSERT INTO sizes VALUES
(1, 'S'),
(2, 'M'),
(3, 'L'),
(4, 'XL');

INSERT INTO colors VALUES
(1, 'Red'),
(2, 'Blue'),
(3, 'Green');

-- CROSS JOIN (explicit)
SELECT s.size_name, c.color_name
FROM sizes s
CROSS JOIN colors c
ORDER BY s.size_name, c.color_name;

-- CROSS JOIN (implicit - comma separated)
SELECT s.size_name, c.color_name
FROM sizes s, colors c
ORDER BY s.size_name, c.color_name;

-- CROSS JOIN with WHERE (effectively an INNER JOIN)
SELECT s.size_name, c.color_name
FROM sizes s
CROSS JOIN colors c
WHERE s.size_id IN (1, 2);

-- CROSS JOIN for generating sequences (date ranges)
-- PostgreSQL: generate_series
-- SELECT d::DATE AS date
-- FROM generate_series('2025-01-01'::DATE, '2025-01-10'::DATE, '1 day') AS d;

-- CROSS JOIN with date series and a table
CREATE TABLE IF NOT EXISTS stores (
    store_id   INT PRIMARY KEY,
    store_name VARCHAR(50)
);

INSERT INTO stores VALUES (1, 'Store A'), (2, 'Store B');

-- Generate all store-date combinations for a report
-- (Conceptual: every store, every day of Jan 2025)
WITH dates AS (
    SELECT DATE('2025-01-01') AS dt
    UNION ALL SELECT DATE('2025-01-02')
    UNION ALL SELECT DATE('2025-01-03')
)
SELECT s.store_name, d.dt
FROM stores s
CROSS JOIN dates d
ORDER BY s.store_name, d.dt;

-- Check total count (should be 4 sizes * 3 colors = 12)
SELECT COUNT(*) AS total_combinations
FROM sizes
CROSS JOIN colors;

-- Cleanup
DROP TABLE IF EXISTS colors;
DROP TABLE IF EXISTS sizes;
DROP TABLE IF EXISTS stores;
