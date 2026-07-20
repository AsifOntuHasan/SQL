-- ============================================================
-- 038: SUM/AVG OVER - window aggregate functions
-- Running totals, moving averages, cumulative statistics
-- ============================================================

CREATE TABLE IF NOT EXISTS sales (
    sale_id    INT PRIMARY KEY,
    sale_date  DATE,
    amount     DECIMAL(10,2)
);

INSERT INTO sales VALUES
(1, '2025-01-01', 1000),
(2, '2025-01-02', 1200),
(3, '2025-01-03',  800),
(4, '2025-01-04', 1500),
(5, '2025-01-05', 1100),
(6, '2025-01-06',  900),
(7, '2025-01-07', 1300);

-- Running total (cumulative sum)
SELECT sale_date, amount,
       SUM(amount) OVER (ORDER BY sale_date) AS running_total
FROM sales
ORDER BY sale_date;

-- Running total with PARTITION BY
CREATE TABLE IF NOT EXISTS product_sales (
    sale_id    INT PRIMARY KEY,
    product    VARCHAR(50),
    sale_date  DATE,
    amount     DECIMAL(10,2)
);
INSERT INTO product_sales VALUES
(1, 'Laptop', '2025-01-01', 1200),
(2, 'Laptop', '2025-01-02', 1100),
(3, 'Laptop', '2025-01-03',  900),
(4, 'Mouse',  '2025-01-01',   25),
(5, 'Mouse',  '2025-01-02',   30),
(6, 'Mouse',  '2025-01-03',   20);

SELECT product, sale_date, amount,
       SUM(amount) OVER (PARTITION BY product ORDER BY sale_date) AS running_total
FROM product_sales
ORDER BY product, sale_date;

-- Moving average (3-day window)
SELECT sale_date, amount,
       AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM sales
ORDER BY sale_date;

-- Moving average (7-day window)
SELECT sale_date, amount,
       AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_7
FROM sales
ORDER BY sale_date;

-- COUNT as window function
SELECT sale_date, amount,
       COUNT(*) OVER (ORDER BY sale_date) AS day_count
FROM sales
ORDER BY sale_date;

-- Multiple window aggregates
SELECT sale_date, amount,
       SUM(amount) OVER (ORDER BY sale_date) AS running_total,
       AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS mov_avg_3,
       MIN(amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_min,
       MAX(amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_max
FROM sales
ORDER BY sale_date;

-- Total and percentage of total
SELECT sale_date, amount,
       SUM(amount) OVER () AS grand_total,
       ROUND(amount * 100.0 / SUM(amount) OVER (), 2) AS pct_of_total
FROM sales
ORDER BY sale_date;

-- Cleanup
DROP TABLE IF EXISTS product_sales;
DROP TABLE IF EXISTS sales;
