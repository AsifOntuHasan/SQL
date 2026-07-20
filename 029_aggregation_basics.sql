-- ============================================================
-- 029: Aggregation Basics - COUNT, SUM, AVG, MIN, MAX
-- ============================================================

CREATE TABLE IF NOT EXISTS sales (
    sale_id     INT PRIMARY KEY,
    product     VARCHAR(50),
    amount      DECIMAL(10,2),
    quantity    INT,
    sale_date   DATE,
    salesperson VARCHAR(50)
);

INSERT INTO sales VALUES
(1, 'Laptop',   1200.00, 1, '2025-01-15', 'Alice'),
(2, 'Mouse',      25.00, 5, '2025-01-16', 'Bob'),
(3, 'Laptop',   1200.00, 1, '2025-02-01', 'Alice'),
(4, 'Keyboard',   75.00, 2, '2025-02-10', 'Charlie'),
(5, 'Mouse',      25.00, 3, '2025-02-15', 'Bob'),
(6, 'Desk',      450.00, 1, '2025-03-01', 'Alice'),
(7, 'Laptop',   1200.00, 1, '2025-03-05', NULL),     -- NULL salesperson
(8, 'Chair',     250.00, 2, '2025-03-10', 'Charlie');

-- COUNT
SELECT COUNT(*) AS total_rows FROM sales;
SELECT COUNT(salesperson) AS non_null_salespeople FROM sales;
SELECT COUNT(DISTINCT product) AS unique_products FROM sales;

-- SUM
SELECT SUM(amount) AS total_revenue FROM sales;
SELECT SUM(quantity) AS total_items_sold FROM sales;

-- AVG
SELECT AVG(amount) AS avg_sale_amount FROM sales;
SELECT AVG(quantity) AS avg_quantity_per_sale FROM sales;

-- MIN and MAX
SELECT MIN(amount) AS min_sale, MAX(amount) AS max_sale FROM sales;
SELECT MIN(sale_date) AS first_sale, MAX(sale_date) AS last_sale FROM sales;

-- Combined aggregation
SELECT COUNT(*) AS num_sales,
       SUM(amount) AS total_revenue,
       AVG(amount) AS avg_revenue,
       MIN(amount) AS min_revenue,
       MAX(amount) AS max_revenue,
       SUM(quantity) AS total_items
FROM sales;

-- Aggregation with GROUP BY
SELECT product, COUNT(*) AS num_sales, SUM(amount) AS revenue
FROM sales
GROUP BY product
ORDER BY revenue DESC;

-- Aggregation with DISTINCT
SELECT COUNT(DISTINCT salesperson) AS active_salespeople FROM sales;

-- Multiple aggregates in one query
SELECT product,
       COUNT(*) AS cnt,
       SUM(amount) AS total,
       AVG(amount) AS avg,
       MIN(amount) AS min,
       MAX(amount) AS max,
       SUM(quantity) AS qty
FROM sales
GROUP BY product
ORDER BY product;

-- Cleanup
DROP TABLE IF EXISTS sales;
