-- ============================================================
-- 017: INNER JOIN - matching rows from both tables
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id   INT PRIMARY KEY,
    name          VARCHAR(100),
    city          VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT,
    order_date    DATE,
    amount        DECIMAL(10,2)
);

INSERT INTO customers VALUES
(1, 'Alice',   'NYC'),
(2, 'Bob',     'LA'),
(3, 'Charlie', 'Chicago'),
(4, 'Diana',   'NYC');

INSERT INTO orders VALUES
(101, 1, '2025-01-15', 1200),
(102, 1, '2025-02-20',  300),
(103, 2, '2025-03-10',  550),
(104, 4, '2025-04-05',  800);

-- Basic INNER JOIN
SELECT c.name, o.order_id, o.order_date, o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- INNER JOIN with WHERE
SELECT c.name, c.city, o.order_id, o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.amount > 500
ORDER BY o.amount DESC;

-- INNER JOIN with aggregation
SELECT c.name, COUNT(o.order_id) AS order_count, SUM(o.amount) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- INNER JOIN with table aliases
SELECT c.name, o.*
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id;

-- INNER JOIN multiple tables (see file 023)
-- INNER JOIN with USING (if column name is the same)
SELECT c.name, o.order_id
FROM customers c
INNER JOIN orders o USING (customer_id);

-- Cleanup
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
