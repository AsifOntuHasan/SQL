-- ============================================================
-- 039: Non-Recursive CTEs (Common Table Expressions)
-- WITH clause for readable, reusable subqueries
-- ============================================================

CREATE TABLE IF NOT EXISTS orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    order_date  DATE,
    total       DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    name        VARCHAR(100),
    city        VARCHAR(50)
);

INSERT INTO customers VALUES
(1, 'Alice',   'NYC'),
(2, 'Bob',     'LA'),
(3, 'Charlie', 'Chicago');

INSERT INTO orders VALUES
(101, 1, '2025-01-15', 1200),
(102, 1, '2025-02-20',  300),
(103, 2, '2025-03-10',  550),
(104, 3, '2025-04-05',  800),
(105, 1, '2025-05-01',  200);

-- Simple CTE
WITH high_value_orders AS (
    SELECT order_id, customer_id, order_date, total
    FROM orders
    WHERE total > 500
)
SELECT * FROM high_value_orders
ORDER BY total DESC;

-- Multiple CTEs
WITH customer_totals AS (
    SELECT customer_id, COUNT(*) AS order_count, SUM(total) AS total_spent
    FROM orders
    GROUP BY customer_id
),
active_customers AS (
    SELECT c.customer_id, c.name, c.city
    FROM customers c
    WHERE c.customer_id IN (SELECT customer_id FROM orders)
)
SELECT ac.name, ac.city, ct.order_count, ct.total_spent
FROM active_customers ac
JOIN customer_totals ct ON ac.customer_id = ct.customer_id
ORDER BY ct.total_spent DESC;

-- CTE used multiple times
WITH avg_calc AS (
    SELECT AVG(total) AS avg_order FROM orders
)
SELECT o.order_id, o.total,
       o.total - ac.avg_order AS diff_from_avg
FROM orders o
CROSS JOIN avg_calc ac;

-- CTE with JOIN
WITH customer_orders AS (
    SELECT c.name, c.city, o.order_id, o.total, o.order_date
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
)
SELECT name, city, COUNT(order_id) AS orders, COALESCE(SUM(total), 0) AS revenue
FROM customer_orders
GROUP BY name, city
ORDER BY revenue DESC;

-- CTE for data transformation
WITH parsed AS (
    SELECT order_id, total,
           CASE WHEN total >= 1000 THEN 'High'
                WHEN total >= 500 THEN 'Medium'
                ELSE 'Low'
           END AS order_tier
    FROM orders
)
SELECT order_tier, COUNT(*) AS count, SUM(total) AS total
FROM parsed
GROUP BY order_tier
ORDER BY total DESC;

-- Cleanup
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
