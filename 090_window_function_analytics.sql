-- ============================================================
-- 090: Advanced Window Analytics - Statistical window functions
-- ============================================================

CREATE TABLE IF NOT EXISTS monthly_revenue (
    month      DATE PRIMARY KEY,
    revenue    DECIMAL(12,2)
);

INSERT INTO monthly_revenue VALUES
('2024-07-01', 100000),
('2024-08-01', 110000),
('2024-09-01', 105000),
('2024-10-01', 120000),
('2024-11-01', 130000),
('2024-12-01', 180000),
('2025-01-01', 115000),
('2025-02-01', 108000),
('2025-03-01', 122000),
('2025-04-01', 135000);

-- FIRST_VALUE, LAST_VALUE with full window frame
SELECT month, revenue,
       FIRST_VALUE(revenue) OVER (ORDER BY month) AS first_revenue,
       LAST_VALUE(revenue) OVER (
           ORDER BY month
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS last_revenue,
       revenue - FIRST_VALUE(revenue) OVER (ORDER BY month) AS growth_since_first
FROM monthly_revenue
ORDER BY month;

-- NTH_VALUE: get nth value (PostgreSQL, SQL Server, Oracle, MySQL 8+)
-- SELECT month, revenue,
--        NTH_VALUE(revenue, 3) OVER (ORDER BY month) AS third_month_revenue
-- FROM monthly_revenue;

-- Moving statistics (window frames)
SELECT month, revenue,
       AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS mov_avg_3,
       AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS mov_avg_lagged,
       STDDEV_SAMP(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS mov_stddev_3,
       VARIANCE(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS mov_variance_3
FROM monthly_revenue
ORDER BY month;

-- ROW and RANGE frames
SELECT month, revenue,
       -- ROWS: physical rows
       AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS neighbors_avg,
       -- RANGE: logical range (values within range)
       -- Not shown as RANGE depends on data distribution
       SUM(revenue) OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;

-- Window functions with FILTER (PostgreSQL, SQLite 3.30+)
-- SELECT month, revenue,
--        AVG(revenue) FILTER (WHERE revenue > 100000) OVER (ORDER BY month) AS avg_above_100k
-- FROM monthly_revenue;

-- Multiple window specifications
SELECT month, revenue,
       revenue - LAG(revenue) OVER (ORDER BY month) AS mom_change,
       revenue - AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS diff_from_annual_avg,
       ROUND((revenue - AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) /
              NULLIF(AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) * 100, 2) AS pct_from_moving_avg
FROM monthly_revenue
ORDER BY month;

-- Median calculation using window functions
SELECT AVG(revenue) AS median_revenue
FROM (
    SELECT revenue,
           ROW_NUMBER() OVER (ORDER BY revenue) AS rn_asc,
           ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rn_desc
    FROM monthly_revenue
) t
WHERE rn_asc IN (rn_desc, rn_desc - 1, rn_desc + 1);

-- Cleanup
DROP TABLE IF EXISTS monthly_revenue;
