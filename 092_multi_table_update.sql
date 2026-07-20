-- ============================================================
-- 092: Multi-table UPDATE and DELETE operations
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id  INT PRIMARY KEY,
    name        VARCHAR(100),
    price       DECIMAL(10,2),
    is_active   INT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS orders (
    order_id    INT PRIMARY KEY,
    product_id  INT,
    quantity    INT,
    total       DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS price_updates (
    product_id  INT PRIMARY KEY,
    new_price   DECIMAL(10,2),
    effective_date DATE
);

INSERT INTO products VALUES (1, 'Laptop', 1200, 1), (2, 'Mouse', 25, 1), (3, 'Keyboard', 75, 0);
INSERT INTO orders VALUES (101, 1, 2, 2400), (102, 2, 5, 125), (103, 3, 1, 75);
INSERT INTO price_updates VALUES (1, 1100, '2025-02-01'), (2, 22, '2025-02-01');

-- PostgreSQL: UPDATE with JOIN
/*
UPDATE products p
SET price = pu.new_price
FROM price_updates pu
WHERE p.product_id = pu.product_id;
*/

-- MySQL: UPDATE with JOIN
/*
UPDATE products p
JOIN price_updates pu ON p.product_id = pu.product_id
SET p.price = pu.new_price;
*/

-- SQL Server: UPDATE with JOIN
/*
UPDATE p SET price = pu.new_price
FROM products p
JOIN price_updates pu ON p.product_id = pu.product_id;
*/

-- SQLite: correlated subquery UPDATE
UPDATE products
SET price = (SELECT new_price FROM price_updates WHERE price_updates.product_id = products.product_id)
WHERE product_id IN (SELECT product_id FROM price_updates);

-- Multi-table DELETE
-- PostgreSQL: DELETE FROM products USING orders WHERE products.product_id = orders.product_id AND products.is_active = 0;
-- MySQL: DELETE products FROM products JOIN orders ON products.product_id = orders.product_id WHERE products.is_active = 0;
-- SQL Server: DELETE products FROM products JOIN orders ON products.product_id = orders.product_id WHERE products.is_active = 0;
-- SQLite: DELETE FROM products WHERE product_id IN (SELECT product_id FROM orders WHERE ...)

-- Soft delete (UPDATE status field)
UPDATE products SET is_active = 0 WHERE product_id = 3;

-- Verify
SELECT * FROM products ORDER BY product_id;

-- Cascade UPDATE through related tables
-- In application code, update order totals after price change
UPDATE orders
SET total = o.quantity * p.price
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.product_id = 1;

-- Cleanup
DROP TABLE IF EXISTS price_updates;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
