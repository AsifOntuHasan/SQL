-- ============================================================
-- 061: Query Optimization - techniques for better performance
-- Sargability, avoiding functions in WHERE, JOIN vs subquery
-- ============================================================

CREATE TABLE IF NOT EXISTS orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    order_date   DATE,
    status       VARCHAR(20),
    total_amount DECIMAL(12,2)
);

INSERT INTO orders VALUES
(1, 101, '2025-01-15', 'completed', 1200),
(2, 102, '2025-06-20', 'pending',   300),
(3, 101, '2025-07-01', 'shipped',   800),
(4, 103, '2025-07-15', 'completed', 550),
(5, 101, '2025-08-01', 'pending',   200);

-- BAD: Function on column prevents index usage (non-sargable)
-- SELECT * FROM orders WHERE YEAR(order_date) = 2025 AND MONTH(order_date) = 7;

-- GOOD: Range comparison uses index
SELECT * FROM orders
WHERE order_date >= '2025-07-01' AND order_date < '2025-08-01';

-- BAD: Wrapping column in function
-- SELECT * FROM orders WHERE UPPER(status) = 'PENDING';

-- GOOD: Compare directly
SELECT * FROM orders WHERE status = 'pending';

-- BAD: Implicit data type conversion
-- SELECT * FROM orders WHERE order_id = '1';  -- string vs int

-- GOOD: Use correct types
SELECT * FROM orders WHERE order_id = 1;

-- JOIN vs Subquery: often JOIN is more efficient
-- BAD: Correlated subquery
SELECT o.*, (SELECT SUM(total_amount) FROM orders o2 WHERE o2.customer_id = o.customer_id) AS customer_total
FROM orders o;

-- GOOD: Window function or JOIN
SELECT o.*, SUM(o.total_amount) OVER (PARTITION BY o.customer_id) AS customer_total
FROM orders o;

-- Selecting only needed columns (avoid SELECT *)
SELECT order_id, customer_id, total_amount
FROM orders
WHERE status = 'completed';

-- Using EXISTS instead of DISTINCT in many cases
-- BAD: DISTINCT with JOIN
SELECT DISTINCT c.name
FROM customers c JOIN orders o ON c.customer_id = o.customer_id;

-- GOOD: EXISTS
-- SELECT c.name FROM customers c WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- Cleanup
DROP TABLE IF EXISTS orders;
