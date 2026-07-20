-- ============================================================
-- 063: E-commerce Analysis Queries
-- Sales, inventory, customer behavior, product performance
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id    INT PRIMARY KEY,
    name          VARCHAR(200),
    price         DECIMAL(10,2),
    category_id   INT,
    stock_qty     INT
);

CREATE TABLE IF NOT EXISTS categories (
    category_id   INT PRIMARY KEY,
    name          VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id   INT PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    city          VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT,
    order_date    DATE,
    status        VARCHAR(20),
    total_amount  DECIMAL(12,2)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id      INT,
    product_id    INT,
    quantity      INT,
    unit_price    DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id)
);

INSERT INTO categories VALUES (1, 'Electronics'), (2, 'Clothing'), (3, 'Books');
INSERT INTO products VALUES (1, 'Laptop', 1200, 1, 10), (2, 'Mouse', 25, 1, 50), (3, 'T-Shirt', 20, 2, 100), (4, 'Book', 15, 3, 200);
INSERT INTO customers VALUES (1, 'Alice', 'Smith', 'NYC'), (2, 'Bob', 'Jones', 'LA'), (3, 'Charlie', 'Brown', 'Chicago');
INSERT INTO orders VALUES (1, 1, '2025-01-15', 'completed', 1225), (2, 2, '2025-02-10', 'completed', 40), (3, 1, '2025-03-05', 'pending', 1200);
INSERT INTO order_items VALUES (1, 1, 1, 1200), (1, 2, 1, 25), (2, 3, 2, 20), (3, 1, 1, 1200);

-- Top-selling products
SELECT p.name, SUM(oi.quantity) AS total_sold, SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY total_sold DESC;

-- Revenue by category
SELECT c.name AS category, SUM(oi.quantity * oi.unit_price) AS revenue
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.name
ORDER BY revenue DESC;

-- Customer lifetime value
SELECT c.first_name || ' ' || c.last_name AS customer,
       COUNT(o.order_id) AS order_count,
       SUM(o.total_amount) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id
ORDER BY lifetime_value DESC;

-- Low stock alert
SELECT name, stock_qty
FROM products
WHERE stock_qty < 20
ORDER BY stock_qty;

-- Abandoned carts (conceptual - needs cart table)
-- SELECT c.first_name, cr.created_at
-- FROM customers c JOIN carts cr ON c.customer_id = cr.customer_id
-- LEFT JOIN orders o ON cr.customer_id = o.customer_id
-- WHERE o.order_id IS NULL;

-- Monthly sales trend
SELECT STRFTIME('%Y-%m', order_date) AS month, COUNT(*) AS orders, SUM(total_amount) AS revenue
FROM orders WHERE status = 'completed'
GROUP BY month ORDER BY month;

-- Product recommendation (customers who bought X also bought Y)
SELECT oi1.product_id AS product_a, oi2.product_id AS product_b, COUNT(*) AS times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
GROUP BY product_a, product_b
ORDER BY times_bought_together DESC;

-- Cleanup
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
