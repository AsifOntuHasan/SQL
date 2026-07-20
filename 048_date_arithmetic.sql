-- ============================================================
-- 048: Date Arithmetic - advanced date calculations
-- ============================================================

CREATE TABLE IF NOT EXISTS subscriptions (
    sub_id        INT PRIMARY KEY,
    user_name     VARCHAR(100),
    start_date    DATE,
    plan_type     VARCHAR(20)   -- 'monthly', 'yearly', 'weekly'
);

INSERT INTO subscriptions VALUES
(1, 'Alice',   '2025-01-15', 'monthly'),
(2, 'Bob',     '2025-02-01', 'yearly'),
(3, 'Charlie', '2025-03-10', 'weekly'),
(4, 'Diana',   '2024-11-20', 'monthly');

-- Calculate end date based on plan
SELECT user_name, start_date, plan_type,
       CASE plan_type
           WHEN 'weekly'  THEN DATE(start_date, '+7 days')
           WHEN 'monthly' THEN DATE(start_date, '+1 month')
           WHEN 'yearly'  THEN DATE(start_date, '+1 year')
       END AS end_date,
       CASE plan_type
           WHEN 'weekly'  THEN DATE(start_date, '+7 days', '-1 day')
           WHEN 'monthly' THEN DATE(start_date, '+1 month', '-1 day')
           WHEN 'yearly'  THEN DATE(start_date, '+1 year', '-1 day')
       END AS last_billable_day
FROM subscriptions;

-- Days remaining until end of month
SELECT user_name, start_date,
       DATE(start_date, 'start of month', '+1 month', '-1 day') AS month_end,
       CAST(JULIANDAY(DATE(start_date, 'start of month', '+1 month', '-1 day')) -
            JULIANDAY(start_date) AS INTEGER) AS days_remaining_month
FROM subscriptions;

-- Next occurrence of a specific day (e.g., next Monday)
-- SQLite: next Monday from a date
SELECT start_date,
       DATE(start_date, '+' || ((9 - CAST(STRFTIME('%w', start_date) AS INTEGER)) % 7) || ' days') AS next_monday
FROM subscriptions;

-- Age calculation in years, months, days
-- SQLite:
SELECT user_name, start_date,
       CAST((JULIANDAY('now') - JULIANDAY(start_date)) / 365.25 AS INTEGER) AS years_since_start,
       CAST((JULIANDAY('now') - JULIANDAY(start_date)) AS INTEGER) AS days_since_start
FROM subscriptions;

-- Find subscriptions expiring within 30 days
SELECT user_name, start_date, plan_type,
       CASE plan_type
           WHEN 'monthly' THEN DATE(start_date, '+1 month')
           WHEN 'yearly'  THEN DATE(start_date, '+1 year')
           WHEN 'weekly'  THEN DATE(start_date, '+7 days')
       END AS next_renewal
FROM subscriptions
WHERE CASE plan_type
          WHEN 'monthly' THEN DATE(start_date, '+1 month')
          WHEN 'yearly'  THEN DATE(start_date, '+1 year')
          WHEN 'weekly'  THEN DATE(start_date, '+7 days')
      END BETWEEN DATE('now') AND DATE('now', '+30 days');

-- Cleanup
DROP TABLE IF EXISTS subscriptions;
