-- ============================================================
-- 036: LEAD & LAG - accessing adjacent rows
-- LAG: previous row; LEAD: next row
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

-- LAG: get previous day's amount
SELECT sale_date, amount,
       LAG(amount) OVER (ORDER BY sale_date) AS prev_day_amount
FROM sales
ORDER BY sale_date;

-- LEAD: get next day's amount
SELECT sale_date, amount,
       LEAD(amount) OVER (ORDER BY sale_date) AS next_day_amount
FROM sales
ORDER BY sale_date;

-- LAG with offset: get 2 days before
SELECT sale_date, amount,
       LAG(amount, 2) OVER (ORDER BY sale_date) AS two_days_ago
FROM sales
ORDER BY sale_date;

-- LAG with default value
SELECT sale_date, amount,
       LAG(amount, 1, 0) OVER (ORDER BY sale_date) AS prev_day_default_zero
FROM sales
ORDER BY sale_date;

-- Day-over-day difference
SELECT sale_date, amount,
       amount - LAG(amount) OVER (ORDER BY sale_date) AS day_over_day_change
FROM sales
ORDER BY sale_date;

-- LAG/LEAD with PARTITION BY
CREATE TABLE IF NOT EXISTS product_sales (
    sale_id    INT PRIMARY KEY,
    product    VARCHAR(50),
    sale_date  DATE,
    amount     DECIMAL(10,2)
);
INSERT INTO product_sales VALUES
(1, 'Laptop', '2025-01-01', 1200),
(2, 'Laptop', '2025-01-02', 1100),
(3, 'Mouse',  '2025-01-01',   25),
(4, 'Mouse',  '2025-01-02',   30);

SELECT product, sale_date, amount,
       LAG(amount) OVER (PARTITION BY product ORDER BY sale_date) AS prev_amount,
       amount - LAG(amount) OVER (PARTITION BY product ORDER BY sale_date) AS change
FROM product_sales
ORDER BY product, sale_date;

-- Percentage change
SELECT sale_date, amount,
       ROUND((amount - LAG(amount) OVER (ORDER BY sale_date)) /
              LAG(amount) OVER (ORDER BY sale_date) * 100, 2) AS pct_change
FROM sales
ORDER BY sale_date;

-- Cleanup
DROP TABLE IF EXISTS product_sales;
DROP TABLE IF EXISTS sales;
