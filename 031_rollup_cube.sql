-- ============================================================
-- 031: ROLLUP & CUBE - multi-level aggregation with subtotals
-- ============================================================

CREATE TABLE IF NOT EXISTS sales (
    sale_id     INT PRIMARY KEY,
    product     VARCHAR(50),
    category    VARCHAR(50),
    region      VARCHAR(50),
    amount      DECIMAL(10,2)
);

INSERT INTO sales VALUES
(1,  'Laptop',   'Electronics', 'North', 1200),
(2,  'Mouse',    'Electronics', 'North',   25),
(3,  'Laptop',   'Electronics', 'South', 1200),
(4,  'Keyboard', 'Electronics', 'North',   75),
(5,  'Mouse',    'Electronics', 'South',   25),
(6,  'Desk',     'Furniture',   'North',  450),
(7,  'Chair',    'Furniture',   'South',  250),
(8,  'Desk',     'Furniture',   'South',  450),
(9,  'Lamp',     'Furniture',   'North',   50);

-- ROLLUP: hierarchical subtotals (category, region, grand total)
SELECT category, region, COUNT(*) AS cnt, SUM(amount) AS total
FROM sales
GROUP BY ROLLUP(category, region)
ORDER BY category, region;

-- ROLLUP with COALESCE for readable labels
SELECT
    COALESCE(category, 'ALL') AS category,
    COALESCE(region, 'ALL') AS region,
    COUNT(*) AS cnt,
    SUM(amount) AS total
FROM sales
GROUP BY ROLLUP(category, region);

-- CUBE: all combinations of subtotals
SELECT
    COALESCE(category, 'ALL') AS category,
    COALESCE(region, 'ALL') AS region,
    SUM(amount) AS total
FROM sales
GROUP BY CUBE(category, region)
ORDER BY category, region;

-- GROUPING SETS: custom subtotal combinations
SELECT
    COALESCE(category, 'ALL') AS category,
    COALESCE(region, 'ALL') AS region,
    SUM(amount) AS total
FROM sales
GROUP BY GROUPING SETS (
    (category, region),
    (category),
    (region),
    ()
)
ORDER BY category, region;

-- GROUPING function to identify subtotal rows (PostgreSQL, SQL Server)
-- SELECT category, region, SUM(amount) AS total,
--        GROUPING(category) AS is_cat_total,
--        GROUPING(region) AS is_reg_total
-- FROM sales
-- GROUP BY ROLLUP(category, region);

-- Cleanup
DROP TABLE IF EXISTS sales;
