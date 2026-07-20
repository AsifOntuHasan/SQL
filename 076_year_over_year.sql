-- ============================================================
-- 076: Year-over-Year (YoY) Comparisons
-- Growth rates, period-over-period analysis
-- ============================================================

CREATE TABLE IF NOT EXISTS monthly_sales (
    sale_month DATE PRIMARY KEY,
    revenue    DECIMAL(12,2)
);

INSERT INTO monthly_sales VALUES
('2024-01-01', 100000),
('2024-02-01', 110000),
('2024-03-01', 105000),
('2024-04-01', 120000),
('2024-05-01', 125000),
('2024-06-01', 130000),
('2024-07-01', 140000),
('2024-08-01', 135000),
('2024-09-01', 145000),
('2024-10-01', 150000),
('2024-11-01', 160000),
('2024-12-01', 200000),
('2025-01-01', 115000),
('2025-02-01', 120000),
('2025-03-01', 118000);

-- YoY comparison: same month, previous year
SELECT sale_month,
       STRFTIME('%Y', sale_month) AS year,
       STRFTIME('%m', sale_month) AS month,
       revenue,
       LAG(revenue, 12) OVER (ORDER BY sale_month) AS revenue_prev_year,
       ROUND((revenue - LAG(revenue, 12) OVER (ORDER BY sale_month)) /
              NULLIF(LAG(revenue, 12) OVER (ORDER BY sale_month), 0) * 100, 2) AS yoy_growth_pct
FROM monthly_sales
ORDER BY sale_month;

-- YoY by extracting year/month
WITH y AS (
    SELECT CAST(STRFTIME('%Y', sale_month) AS INTEGER) AS year,
           CAST(STRFTIME('%m', sale_month) AS INTEGER) AS month,
           revenue
    FROM monthly_sales
)
SELECT a.year, a.month, a.revenue,
       b.revenue AS prev_year_revenue,
       ROUND((a.revenue - b.revenue) / NULLIF(b.revenue, 0) * 100, 2) AS yoy_growth
FROM y a
LEFT JOIN y b ON a.month = b.month AND a.year = b.year + 1
ORDER BY a.year, a.month;

-- Month-over-month (MoM) comparison
SELECT sale_month, revenue,
       LAG(revenue) OVER (ORDER BY sale_month) AS prev_month_revenue,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY sale_month)) /
              NULLIF(LAG(revenue) OVER (ORDER BY sale_month), 0) * 100, 2) AS mom_growth_pct
FROM monthly_sales
ORDER BY sale_month;

-- Year-to-date comparison
WITH ytd AS (
    SELECT sale_month,
           SUM(revenue) OVER (PARTITION BY STRFTIME('%Y', sale_month) ORDER BY sale_month) AS ytd_revenue
    FROM monthly_sales
)
SELECT sale_month, ytd_revenue
FROM ytd
ORDER BY sale_month;

-- Same period last year vs current (e.g., Q1)
SELECT STRFTIME('%Y', sale_month) AS year,
       SUM(revenue) AS q1_revenue,
       LAG(SUM(revenue)) OVER (ORDER BY STRFTIME('%Y', sale_month)) AS q1_prev_year,
       ROUND((SUM(revenue) - LAG(SUM(revenue)) OVER (ORDER BY STRFTIME('%Y', sale_month))) /
              NULLIF(LAG(SUM(revenue)) OVER (ORDER BY STRFTIME('%Y', sale_month)), 0) * 100, 2) AS yoy_q1_growth
FROM monthly_sales
WHERE CAST(STRFTIME('%m', sale_month) AS INTEGER) BETWEEN 1 AND 3
GROUP BY year
ORDER BY year;

-- Cleanup
DROP TABLE IF EXISTS monthly_sales;
