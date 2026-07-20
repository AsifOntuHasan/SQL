-- ============================================================
-- 046: DATEADD & DATEDIFF - date arithmetic
-- Note: function names vary by database
-- ============================================================

CREATE TABLE IF NOT EXISTS projects (
    project_id   INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date   DATE,
    end_date     DATE
);

INSERT INTO projects VALUES
(1, 'Website Redesign', '2025-01-01', '2025-03-15'),
(2, 'Mobile App',       '2025-02-01', '2025-06-30'),
(3, 'Database Migration','2025-04-01', '2025-05-15'),
(4, 'Cloud Setup',      '2025-03-01', '2025-03-20');

-- DATEDIFF: difference between dates
-- SQL Server:            DATEDIFF(day, start_date, end_date)
-- MySQL:                 DATEDIFF(end_date, start_date)
-- PostgreSQL:            end_date - start_date (or DATE_PART('day', end_date - start_date))
-- SQLite:                julianday(end_date) - julianday(start_date)

-- Generic approach using Julian days (SQLite compatible)
SELECT project_name, start_date, end_date,
       CAST(JULIANDAY(end_date) - JULIANDAY(start_date) AS INTEGER) AS duration_days
FROM projects;

-- DATEADD: add to a date
-- SQL Server:            DATEADD(day, 10, start_date)
-- MySQL:                 DATE_ADD(start_date, INTERVAL 10 DAY)
-- PostgreSQL:            start_date + INTERVAL '10 days'
-- SQLite:                DATE(start_date, '+10 days')

SELECT project_name, start_date,
       DATE(start_date, '+7 days') AS one_week_later,
       DATE(start_date, '+1 month') AS one_month_later,
       DATE(start_date, '+1 year') AS one_year_later
FROM projects;

-- Calculate age (years between dates)
SELECT project_name, start_date, end_date,
       CAST((JULIANDAY(end_date) - JULIANDAY(start_date)) / 365.25 AS INTEGER) AS years_diff
FROM projects;

-- Find overdue projects (past current date)
-- SELECT project_name, end_date,
--        JULIANDAY('now') - JULIANDAY(end_date) AS days_overdue
-- FROM projects
-- WHERE end_date < DATE('now');

-- Add business days (simplified)
SELECT project_name, start_date, end_date,
       CAST(JULIANDAY(end_date) - JULIANDAY(start_date) AS INTEGER) -
       2 * (CAST(JULIANDAY(end_date) - JULIANDAY(start_date) AS INTEGER) / 7) AS approx_weekdays
FROM projects;

-- Cleanup
DROP TABLE IF EXISTS projects;
