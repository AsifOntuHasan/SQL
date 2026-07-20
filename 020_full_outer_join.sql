-- ============================================================
-- 020: FULL OUTER JOIN - all rows from both tables
-- ============================================================

CREATE TABLE IF NOT EXISTS table_a (
    id    INT PRIMARY KEY,
    val   VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS table_b (
    id    INT PRIMARY KEY,
    val   VARCHAR(50)
);

INSERT INTO table_a VALUES
(1, 'A1'),
(2, 'A2'),
(3, 'A3');

INSERT INTO table_b VALUES
(2, 'B2'),
(3, 'B3'),
(4, 'B4');

-- FULL OUTER JOIN: all rows from both sides
SELECT COALESCE(a.id, b.id) AS id,
       a.val AS a_val,
       b.val AS b_val
FROM table_a a
FULL OUTER JOIN table_b b ON a.id = b.id
ORDER BY id;

-- FULL OUTER JOIN with WHERE to find unmatched rows
SELECT COALESCE(a.id, b.id) AS id,
       a.val AS a_val,
       b.val AS b_val
FROM table_a a
FULL OUTER JOIN table_b b ON a.id = b.id
WHERE a.id IS NULL OR b.id IS NULL
ORDER BY id;

-- FULL OUTER JOIN in SQLite (not natively supported) can be simulated:
-- SELECT * FROM table_a LEFT JOIN table_b USING(id)
-- UNION
-- SELECT * FROM table_a RIGHT JOIN table_b USING(id);

-- FULL OUTER JOIN with aggregation
SELECT COALESCE(a.id, b.id) AS id,
       CASE WHEN a.val IS NOT NULL AND b.val IS NOT NULL THEN 'Both'
            WHEN a.val IS NOT NULL THEN 'Only A'
            WHEN b.val IS NOT NULL THEN 'Only B'
       END AS source
FROM table_a a
FULL OUTER JOIN table_b b ON a.id = b.id;

-- Cleanup
DROP TABLE IF EXISTS table_a;
DROP TABLE IF EXISTS table_b;
