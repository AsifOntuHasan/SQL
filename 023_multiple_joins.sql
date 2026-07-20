-- ============================================================
-- 023: Multiple JOINs - joining three or more tables
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
    total_amount  DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id      INT,
    product_id    INT,
    quantity      INT,
    unit_price    DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE IF NOT EXISTS products (
    product_id    INT PRIMARY KEY,
    product_name  VARCHAR(100),
    category      VARCHAR(50)
);

INSERT INTO customers VALUES (1, 'Alice', 'NYC'), (2, 'Bob', 'LA');
INSERT INTO orders VALUES (101, 1, '2025-01-15', 1225), (102, 2, '2025-02-20', 150);
INSERT INTO order_items VALUES (101, 1, 1, 1200), (101, 2, 1, 25), (102, 2, 6, 25);
INSERT INTO products VALUES (1, 'Laptop', 'Electronics'), (2, 'Mouse', 'Electronics'), (3, 'Keyboard', 'Electronics');

-- Three-table join
SELECT c.name AS customer, o.order_id, o.order_date,
       p.product_name, oi.quantity, oi.unit_price
FROM customers c
JOIN orders o       ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
ORDER BY o.order_id, p.product_name;

-- Four-table join with aggregation
SELECT c.name, COUNT(DISTINCT o.order_id) AS order_count,
       SUM(oi.quantity * oi.unit_price) AS total_spent,
       COUNT(DISTINCT p.product_id) AS unique_products
FROM customers c
LEFT JOIN orders o       ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p     ON oi.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- Multiple joins with mixed types (INNER + LEFT)
SELECT c.name, o.order_id, o.order_date, oi.product_id, p.product_name
FROM customers c
LEFT JOIN orders o       ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p     ON oi.product_id = p.product_id AND p.category = 'Electronics'
ORDER BY c.name, o.order_id;

-- Joining same table multiple times (e.g., billing & shipping addresses)
-- Not shown here but similar to self-join pattern

-- Cleanup
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
