-- ============================================================
-- 047: EXTRACT & FORMAT - getting date parts and formatting
-- ============================================================

CREATE TABLE IF NOT EXISTS sales (
    sale_id    INT PRIMARY KEY,
    sale_date  DATE,
    amount     DECIMAL(10,2)
);

INSERT INTO sales VALUES
(1, '2025-01-05', 100),
(2, '2025-01-15', 200),
(3, '2025-02-10', 150),
(4, '2025-02-20', 300),
(5, '2025-03-08', 250),
(6, '2025-03-25', 180);

-- EXTRACT: get date parts
-- PostgreSQL: EXTRACT(YEAR FROM sale_date)
-- MySQL:      EXTRACT(YEAR FROM sale_date)
-- SQL Server: DATEPART(year, sale_date)
-- SQLite:     CAST(STRFTIME('%Y', sale_date) AS INTEGER)

-- SQLite compatible:
SELECT sale_date,
       CAST(STRFTIME('%Y', sale_date) AS INTEGER) AS year,
       CAST(STRFTIME('%m', sale_date) AS INTEGER) AS month,
       CAST(STRFTIME('%d', sale_date) AS INTEGER) AS day,
       STRFTIME('%w', sale_date) AS weekday_num,  -- 0=Sunday
       CASE CAST(STRFTIME('%w', sale_date) AS INTEGER)
           WHEN 0 THEN 'Sunday'
           WHEN 1 THEN 'Monday'
           WHEN 2 THEN 'Tuesday'
           WHEN 3 THEN 'Wednesday'
           WHEN 4 THEN 'Thursday'
           WHEN 5 THEN 'Friday'
           WHEN 6 THEN 'Saturday'
       END AS weekday_name
FROM sales;

-- FORMAT / TO_CHAR: format date as string
-- PostgreSQL: TO_CHAR(sale_date, 'YYYY-MM-DD')
-- MySQL:      DATE_FORMAT(sale_date, '%Y-%m-%d')
-- SQL Server: FORMAT(sale_date, 'yyyy-MM-dd')
-- SQLite:     STRFTIME('%Y-%m-%d', sale_date)

SELECT sale_date,
       STRFTIME('%Y-%m-%d', sale_date) AS iso_format,
       STRFTIME('%m/%d/%Y', sale_date) AS us_format,
       STRFTIME('%d-%b-%Y', sale_date) AS abbr_month_format,
       STRFTIME('%Y-%m', sale_date) AS year_month
FROM sales;

-- Group by extracted parts
SELECT CAST(STRFTIME('%Y', sale_date) AS INTEGER) AS year,
       CAST(STRFTIME('%m', sale_date) AS INTEGER) AS month,
       COUNT(*) AS sales_count,
       SUM(amount) AS total
FROM sales
GROUP BY year, month
ORDER BY year, month;

-- Quarter extraction
SELECT sale_date,
       CASE
           WHEN CAST(STRFTIME('%m', sale_date) AS INTEGER) BETWEEN 1 AND 3 THEN 'Q1'
           WHEN CAST(STRFTIME('%m', sale_date) AS INTEGER) BETWEEN 4 AND 6 THEN 'Q2'
           WHEN CAST(STRFTIME('%m', sale_date) AS INTEGER) BETWEEN 7 AND 9 THEN 'Q3'
           WHEN CAST(STRFTIME('%m', sale_date) AS INTEGER) BETWEEN 10 AND 12 THEN 'Q4'
       END AS quarter
FROM sales;

-- First/last day of month (SQLite)
SELECT sale_date,
       DATE(sale_date, 'start of month') AS first_of_month,
       DATE(sale_date, 'start of month', '+1 month', '-1 day') AS last_of_month
FROM sales;

-- Cleanup
DROP TABLE IF EXISTS sales;
