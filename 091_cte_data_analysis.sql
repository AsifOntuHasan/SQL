-- ============================================================
-- 091: CTE Data Analysis - complex analysis using CTEs
-- ============================================================

CREATE TABLE IF NOT EXISTS sales (
    sale_id     INT PRIMARY KEY,
    product     VARCHAR(50),
    amount      DECIMAL(10,2),
    sale_date   DATE,
    region      VARCHAR(20)
);

INSERT INTO sales VALUES
(1,  'Laptop',   1200, '2025-01-05',  'North'),
(2,  'Laptop',   1200, '2025-01-15',  'South'),
(3,  'Mouse',     25, '2025-01-20',  'North'),
(4,  'Keyboard',  75, '2025-02-01',  'East'),
(5,  'Laptop',   1200, '2025-02-10',  'North'),
(6,  'Mouse',     25, '2025-02-15',  'West'),
(7,  'Desk',     450, '2025-03-01',  'South'),
(8,  'Chair',    250, '2025-03-05',  'North'),
(9,  'Laptop',   1200, '2025-03-10',  'East'),
(10, 'Desk',     450, '2025-03-15',  'North');

-- CTE chain: multiple CTEs for layered analysis
WITH product_stats AS (
    SELECT product, COUNT(*) AS sale_count, SUM(amount) AS total_revenue,
           AVG(amount) AS avg_price
    FROM sales
    GROUP BY product
),
monthly AS (
    SELECT STRFTIME('%Y-%m', sale_date) AS month, product, SUM(amount) AS revenue
    FROM sales
    GROUP BY month, product
),
ranked_products AS (
    SELECT product, total_revenue,
           ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank
    FROM product_stats
)
SELECT 'Product Summary' AS analysis_type, * FROM product_stats
UNION ALL
SELECT 'Monthly Product', month, revenue, NULL, NULL FROM monthly
UNION ALL
SELECT 'Product Ranking', product, total_revenue, NULL, NULL FROM ranked_products;

-- CTE with window functions
WITH daily_sales AS (
    SELECT sale_date, SUM(amount) AS daily_total
    FROM sales GROUP BY sale_date
),
comparison AS (
    SELECT sale_date, daily_total,
           AVG(daily_total) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg,
           daily_total - LAG(daily_total) OVER (ORDER BY sale_date) AS change_from_prev
    FROM daily_sales
)
SELECT sale_date, daily_total, ROUND(moving_avg, 2) AS mov_avg_3,
       COALESCE(change_from_prev, 0) AS daily_change
FROM comparison
ORDER BY sale_date;

-- CTE for cohort analysis (simplified)
WITH first_purchase AS (
    SELECT product, MIN(sale_date) AS first_sale_date
    FROM sales
    GROUP BY product
),
cohort AS (
    SELECT s.product, s.sale_date, s.amount,
           CAST(JULIANDAY(s.sale_date) - JULIANDAY(fp.first_sale_date) AS INTEGER) AS days_since_first
    FROM sales s
    JOIN first_purchase fp ON s.product = fp.product
)
SELECT product, days_since_first, SUM(amount) AS revenue
FROM cohort
WHERE days_since_first > 0
GROUP BY product, days_since_first
ORDER BY product, days_since_first;

-- Cleanup
DROP TABLE IF EXISTS sales;
