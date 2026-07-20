-- ============================================================
-- 078: PIVOT - converting rows to columns
-- Note: PIVOT is database-specific; shown via CASE aggregation
-- (works in all databases) and native PIVOT syntax (SQL Server)
-- ============================================================

CREATE TABLE IF NOT EXISTS sales (
    sale_id    INT PRIMARY KEY,
    product    VARCHAR(50),
    year       INT,
    quarter    VARCHAR(2),
    amount     DECIMAL(10,2)
);

INSERT INTO sales VALUES
(1,  'Laptop',  2024, 'Q1', 12000),
(2,  'Laptop',  2024, 'Q2', 15000),
(3,  'Laptop',  2024, 'Q3', 13500),
(4,  'Laptop',  2024, 'Q4', 18000),
(5,  'Mouse',   2024, 'Q1',  5000),
(6,  'Mouse',   2024, 'Q2',  5500),
(7,  'Mouse',   2024, 'Q3',  4800),
(8,  'Mouse',   2024, 'Q4',  6000),
(9,  'Keyboard',2024, 'Q1',  3000),
(10, 'Keyboard',2024, 'Q2',  3500),
(11, 'Keyboard',2024, 'Q3',  3200),
(12, 'Keyboard',2024, 'Q4',  4000);

-- Manual PIVOT using CASE (cross-database)
SELECT product,
       SUM(CASE WHEN quarter = 'Q1' THEN amount ELSE 0 END) AS q1,
       SUM(CASE WHEN quarter = 'Q2' THEN amount ELSE 0 END) AS q2,
       SUM(CASE WHEN quarter = 'Q3' THEN amount ELSE 0 END) AS q3,
       SUM(CASE WHEN quarter = 'Q4' THEN amount ELSE 0 END) AS q4,
       SUM(amount) AS total
FROM sales
WHERE year = 2024
GROUP BY product
ORDER BY product;

-- Pivot with multiple aggregates
SELECT product,
       SUM(CASE WHEN quarter = 'Q1' THEN amount ELSE 0 END) AS q1_sales,
       AVG(CASE WHEN quarter = 'Q1' THEN amount ELSE NULL END) AS q1_avg,
       SUM(CASE WHEN quarter = 'Q2' THEN amount ELSE 0 END) AS q2_sales,
       AVG(CASE WHEN quarter = 'Q2' THEN amount ELSE NULL END) AS q2_avg
FROM sales
WHERE year = 2024
GROUP BY product;

-- SQL Server native PIVOT:
/*
SELECT product, [Q1], [Q2], [Q3], [Q4]
FROM (
    SELECT product, quarter, amount
    FROM sales
    WHERE year = 2024
) AS src
PIVOT (
    SUM(amount)
    FOR quarter IN ([Q1], [Q2], [Q3], [Q4])
) AS pvt;
*/

-- PostgreSQL crosstab (requires tablefunc extension):
/*
SELECT * FROM crosstab(
    'SELECT product, quarter, SUM(amount) FROM sales WHERE year = 2024 GROUP BY product, quarter ORDER BY 1,2',
    'SELECT DISTINCT quarter FROM sales ORDER BY 1'
) AS ct(product VARCHAR, Q1 DECIMAL, Q2 DECIMAL, Q3 DECIMAL, Q4 DECIMAL);
*/

-- Dynamic pivot (product rows become columns)
SELECT quarter,
       SUM(CASE WHEN product = 'Laptop' THEN amount ELSE 0 END) AS laptop,
       SUM(CASE WHEN product = 'Mouse' THEN amount ELSE 0 END) AS mouse,
       SUM(CASE WHEN product = 'Keyboard' THEN amount ELSE 0 END) AS keyboard
FROM sales
WHERE year = 2024
GROUP BY quarter
ORDER BY quarter;

-- Cleanup
DROP TABLE IF EXISTS sales;
