-- ============================================================
-- 086: Sales Reports - revenue, trends, top sellers, forecasts
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    name         VARCHAR(100),
    category     VARCHAR(50),
    cost         DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS sales (
    sale_id      INT PRIMARY KEY,
    product_id   INT,
    sale_date    DATE,
    quantity     INT,
    unit_price   DECIMAL(10,2)
);

INSERT INTO products VALUES
(1, 'Laptop',   'Electronics', 800),
(2, 'Mouse',    'Electronics', 10),
(3, 'Keyboard', 'Electronics', 30),
(4, 'Desk',     'Furniture',   250),
(5, 'Chair',    'Furniture',   150);

INSERT INTO sales VALUES
(1,  1, '2025-01-05', 2, 1200),
(2,  2, '2025-01-06', 10, 25),
(3,  3, '2025-01-07', 3, 75),
(4,  1, '2025-01-10', 1, 1200),
(5,  4, '2025-01-12', 2, 450),
(6,  2, '2025-01-15', 5, 25),
(7,  5, '2025-01-20', 3, 250),
(8,  3, '2025-02-01', 2, 75),
(9,  1, '2025-02-05', 1, 1150),
(10, 4, '2025-02-10', 1, 450);

-- Daily sales report
SELECT sale_date, COUNT(*) AS num_sales, SUM(quantity) AS items_sold, SUM(quantity * unit_price) AS revenue
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

-- Weekly sales report
SELECT STRFTIME('%Y-%W', sale_date) AS week,
       COUNT(*) AS orders,
       SUM(quantity) AS items,
       SUM(quantity * unit_price) AS revenue
FROM sales
GROUP BY week
ORDER BY week;

-- Monthly sales report with totals
SELECT STRFTIME('%Y-%m', sale_date) AS month,
       SUM(quantity * unit_price) AS revenue,
       COUNT(*) AS transactions,
       SUM(quantity) AS units_sold,
       ROUND(SUM(quantity * unit_price) / COUNT(*), 2) AS avg_order_value
FROM sales
GROUP BY month
ORDER BY month;

-- Top 5 products by revenue
SELECT p.name, p.category,
       SUM(s.quantity * s.unit_price) AS revenue,
       SUM(s.quantity) AS units_sold,
       SUM(s.quantity * (s.unit_price - p.cost)) AS profit
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.name, p.category
ORDER BY revenue DESC
LIMIT 5;

-- Category performance
SELECT p.category,
       COUNT(DISTINCT s.sale_id) AS sales_count,
       SUM(s.quantity) AS total_units,
       SUM(s.quantity * s.unit_price) AS revenue,
       SUM(s.quantity * (s.unit_price - p.cost)) AS profit,
       ROUND(SUM(s.quantity * (s.unit_price - p.cost)) / NULLIF(SUM(s.quantity * s.unit_price), 0) * 100, 1) AS margin_pct
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- Revenue by product with running total
SELECT s.sale_date, p.name, s.quantity, s.unit_price,
       s.quantity * s.unit_price AS line_total,
       SUM(s.quantity * s.unit_price) OVER (PARTITION BY p.name ORDER BY s.sale_date) AS product_running
FROM sales s
JOIN products p ON s.product_id = p.product_id
ORDER BY p.name, s.sale_date;

-- Sales vs target (assumes 1000/day target)
WITH daily AS (
    SELECT sale_date, SUM(quantity * unit_price) AS revenue
    FROM sales GROUP BY sale_date
)
SELECT sale_date, revenue, 1000 AS daily_target,
       revenue - 1000 AS variance,
       ROUND((revenue - 1000) / 1000.0 * 100, 1) AS pct_vs_target
FROM daily
ORDER BY sale_date;

-- Cleanup
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
