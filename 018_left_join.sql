-- ============================================================
-- 018: LEFT JOIN (LEFT OUTER JOIN) - all left table rows
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id   INT PRIMARY KEY,
    name          VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT,
    product       VARCHAR(50),
    amount        DECIMAL(10,2)
);

INSERT INTO customers VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');

INSERT INTO orders VALUES
(101, 1, 'Laptop', 1200),
(102, 1, 'Mouse',    25),
(103, 2, 'Keyboard', 75);

-- LEFT JOIN: shows all customers, even those without orders
SELECT c.customer_id, c.name, o.order_id, o.product, o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- LEFT JOIN to find records in left table not in right table
SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- LEFT JOIN with aggregation
SELECT c.name, COUNT(o.order_id) AS order_count,
       COALESCE(SUM(o.amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- LEFT JOIN with WHERE conditions on right table
-- (be careful: condition on right table in WHERE effectively turns it into INNER JOIN)
-- Correct way to filter right table in LEFT JOIN:
SELECT c.name, o.product, o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.amount > 100;

-- Cleanup
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
