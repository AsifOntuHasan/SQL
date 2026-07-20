-- ============================================================
-- 016: DISTINCT - removing duplicate rows from results
-- ============================================================

CREATE TABLE IF NOT EXISTS orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    product     VARCHAR(50),
    region      VARCHAR(50),
    order_date  DATE
);

INSERT INTO orders VALUES
(1, 101, 'Laptop',   'North', '2025-01-01'),
(2, 102, 'Mouse',    'North', '2025-01-02'),
(3, 101, 'Laptop',   'North', '2025-02-01'),
(4, 103, 'Keyboard', 'South', '2025-02-10'),
(5, 101, 'Mouse',    'North', '2025-03-01'),
(6, 104, 'Desk',     'South', '2025-03-05'),
(7, 102, 'Laptop',   'North', '2025-03-10');

-- Basic DISTINCT on single column
SELECT DISTINCT product FROM orders;

-- DISTINCT on multiple columns
SELECT DISTINCT product, region FROM orders;

-- DISTINCT COUNT (unique values)
SELECT COUNT(DISTINCT product) AS unique_products FROM orders;

-- DISTINCT vs ALL (default)
SELECT ALL product FROM orders;     -- includes duplicates
SELECT DISTINCT product FROM orders; -- no duplicates

-- DISTINCT with ORDER BY
SELECT DISTINCT product, region
FROM orders
ORDER BY product, region;

-- DISTINCT with WHERE
SELECT DISTINCT product
FROM orders
WHERE region = 'North';

-- Simulate DISTINCT ON (PostgreSQL)
-- SELECT DISTINCT ON (customer_id) customer_id, product, region
-- FROM orders ORDER BY customer_id, order_date DESC;

-- Using GROUP BY instead of DISTINCT (often same result)
SELECT product FROM orders GROUP BY product;

-- COUNT DISTINCT across multiple columns (concatenation approach)
SELECT COUNT(DISTINCT product || '-' || region) AS unique_combos FROM orders;

-- Cleanup
DROP TABLE IF EXISTS orders;
