-- ============================================================
-- 027: EXISTS / NOT EXISTS - testing for existence of rows
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id   INT PRIMARY KEY,
    name          VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT,
    order_date    DATE,
    amount        DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS returns (
    return_id     INT PRIMARY KEY,
    order_id      INT,
    reason        VARCHAR(100)
);

INSERT INTO customers VALUES
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie'), (4, 'Diana');

INSERT INTO orders VALUES
(101, 1, '2025-01-15', 1200),
(102, 1, '2025-02-20', 300),
(103, 2, '2025-03-10', 550),
(104, 3, '2025-04-05', 800),
(105, 4, '2025-05-01', 1500);

INSERT INTO returns VALUES
(1, 101, 'Defective'),
(2, 104, 'Wrong item');

-- EXISTS: customers who have placed at least one order
SELECT c.customer_id, c.name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- NOT EXISTS: customers who have never placed an order
SELECT c.customer_id, c.name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);

-- EXISTS with multiple conditions
SELECT c.name, o.order_id, o.amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE EXISTS (
    SELECT 1 FROM returns r WHERE r.order_id = o.order_id
);

-- NOT EXISTS: orders with no returns
SELECT o.order_id, o.amount, o.order_date
FROM orders o
WHERE NOT EXISTS (
    SELECT 1 FROM returns r WHERE r.order_id = o.order_id
);

-- EXISTS is often more efficient than IN for large result sets
-- Equivalent to IN but often faster:
SELECT name FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);

-- EXISTS with correlated subquery: complex condition
SELECT c.name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
    AND o.amount > 1000
);

-- Cleanup
DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
