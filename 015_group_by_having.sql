-- ============================================================
-- 015: GROUP BY & HAVING - aggregating grouped data
-- ============================================================

CREATE TABLE IF NOT EXISTS sales (
    sale_id     INT PRIMARY KEY,
    product     VARCHAR(50),
    category    VARCHAR(50),
    amount      DECIMAL(10,2),
    sale_date   DATE,
    region      VARCHAR(50)
);

INSERT INTO sales VALUES
(1,  'Laptop',   'Electronics', 1200, '2025-01-15', 'North'),
(2,  'Mouse',    'Electronics',   25, '2025-01-16', 'North'),
(3,  'Laptop',   'Electronics', 1200, '2025-02-01', 'South'),
(4,  'Keyboard', 'Electronics',   75, '2025-02-10', 'North'),
(5,  'Mouse',    'Electronics',   25, '2025-02-15', 'South'),
(6,  'Desk',     'Furniture',    450, '2025-03-01', 'North'),
(7,  'Chair',    'Furniture',    250, '2025-03-05', 'South'),
(8,  'Desk',     'Furniture',    450, '2025-03-10', 'North');

-- Simple GROUP BY
SELECT category, COUNT(*) AS sale_count
FROM sales
GROUP BY category;

-- GROUP BY with multiple columns
SELECT category, region, COUNT(*) AS cnt, SUM(amount) AS total
FROM sales
GROUP BY category, region
ORDER BY category, region;

-- GROUP BY with HAVING (filter groups)
SELECT category, SUM(amount) AS total_revenue
FROM sales
GROUP BY category
HAVING SUM(amount) > 500;

-- GROUP BY with HAVING and WHERE
SELECT category, region, AVG(amount) AS avg_sale
FROM sales
WHERE sale_date >= '2025-02-01'
GROUP BY category, region
HAVING AVG(amount) > 100
ORDER BY avg_sale DESC;

-- GROUP BY with ROLLUP (subtotals)
-- Works in: PostgreSQL, MySQL, SQL Server, SQLite 3.39+
SELECT category, region, SUM(amount) AS total
FROM sales
GROUP BY ROLLUP(category, region)
ORDER BY category, region;

-- GROUP BY with CUBE (all combinations)
-- SELECT category, region, SUM(amount) AS total
-- FROM sales
-- GROUP BY CUBE(category, region)
-- ORDER BY category, region;

-- GROUP BY with GROUPING SETS
-- SELECT category, region, SUM(amount) AS total
-- FROM sales
-- GROUP BY GROUPING SETS ((category), (region), ())
-- ORDER BY category, region;

-- Cleanup
DROP TABLE IF EXISTS sales;
