-- ============================================================
-- 077: Cumulative Sums - various cumulative aggregation patterns
-- ============================================================

CREATE TABLE IF NOT EXISTS goals (
    goal_date    DATE PRIMARY KEY,
    daily_target INT DEFAULT 100,
    actual_done  INT
);

INSERT INTO goals VALUES
('2025-01-01', 100, 90),
('2025-01-02', 100, 110),
('2025-01-03', 100, 95),
('2025-01-04', 100, 120),
('2025-01-05', 100, 80),
('2025-01-06', 100, 105),
('2025-01-07', 100, 115);

-- Cumulative actual
SELECT goal_date, actual_done,
       SUM(actual_done) OVER (ORDER BY goal_date) AS cumulative_actual
FROM goals
ORDER BY goal_date;

-- Cumulative target
SELECT goal_date, daily_target,
       SUM(daily_target) OVER (ORDER BY goal_date) AS cumulative_target
FROM goals
ORDER BY goal_date;

-- Cumulative variance
SELECT goal_date, daily_target, actual_done,
       SUM(actual_done) OVER (ORDER BY goal_date) - SUM(daily_target) OVER (ORDER BY goal_date) AS cumulative_var
FROM goals
ORDER BY goal_date;

-- Cumulative achievement percentage
SELECT goal_date,
       ROUND(SUM(actual_done) OVER (ORDER BY goal_date) * 100.0 /
              SUM(daily_target) OVER (ORDER BY goal_date), 2) AS cumulative_pct
FROM goals
ORDER BY goal_date;

-- Running balance (like checkbook)
CREATE TABLE IF NOT EXISTS transactions (
    tx_id    INT PRIMARY KEY,
    tx_date  DATE,
    amount   DECIMAL(10,2),   -- positive = deposit, negative = withdrawal
    description VARCHAR(200)
);

INSERT INTO transactions VALUES
(1, '2025-01-01',  1000.00, 'Starting balance'),
(2, '2025-01-02',  -200.00, 'Rent payment'),
(3, '2025-01-03',   500.00, 'Freelance income'),
(4, '2025-01-04',   -50.00, 'Groceries'),
(5, '2025-01-05',   -30.00, 'Coffee shop'),
(6, '2025-01-06',  1000.00, 'Salary deposit');

SELECT tx_date, description, amount,
       SUM(amount) OVER (ORDER BY tx_date, tx_id) AS running_balance
FROM transactions
ORDER BY tx_date;

-- Cumulative sum with reset (e.g., cumulative per year)
CREATE TABLE IF NOT EXISTS annual_sales (
    sale_date DATE PRIMARY KEY,
    amount    DECIMAL(10,2)
);
INSERT INTO annual_sales VALUES
('2024-01-15', 1000), ('2024-02-15', 1500), ('2024-03-15', 1200),
('2025-01-15', 2000), ('2025-02-15', 2500);

SELECT sale_date, amount,
       SUM(amount) OVER (PARTITION BY STRFTIME('%Y', sale_date) ORDER BY sale_date) AS ytd_total
FROM annual_sales
ORDER BY sale_date;

-- Cleanup
DROP TABLE IF EXISTS annual_sales;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS goals;
