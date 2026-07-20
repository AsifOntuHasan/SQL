-- ============================================================
-- 010: UPDATE - single row, multi-row, correlated, joins
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id    INT PRIMARY KEY,
    name          VARCHAR(100),
    price         DECIMAL(10,2),
    stock_qty     INT,
    status        VARCHAR(20),
    last_updated  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS price_changes (
    product_id    INT,
    old_price     DECIMAL(10,2),
    new_price     DECIMAL(10,2),
    change_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products VALUES
(1, 'Laptop',   1200.00, 10, 'active',  NULL),
(2, 'Mouse',      25.00,  0, 'active',  NULL),
(3, 'Keyboard',   75.00, 30, 'discontinued', NULL),
(4, 'Monitor',   300.00,  5, 'active',  NULL);

-- Basic UPDATE single row
UPDATE products SET price = 1150.00 WHERE product_id = 1;

-- UPDATE multiple columns
UPDATE products
SET price = 22.00, last_updated = CURRENT_TIMESTAMP
WHERE product_id = 2;

-- UPDATE all rows
UPDATE products SET last_updated = CURRENT_TIMESTAMP;

-- UPDATE with expression
UPDATE products
SET price = price * 1.10  -- 10% price increase
WHERE status = 'active';

-- UPDATE with subquery
UPDATE products
SET status = 'out_of_stock'
WHERE stock_qty = 0;

-- UPDATE from another table (correlated)
-- PostgreSQL:   UPDATE products p SET price = pc.new_price
--               FROM price_changes pc WHERE p.product_id = pc.product_id;
-- MySQL:        UPDATE products p JOIN price_changes pc ON p.product_id = pc.product_id
--               SET p.price = pc.new_price;
-- SQL Server:   UPDATE p SET price = pc.new_price
--               FROM products p JOIN price_changes pc ON p.product_id = pc.product_id;
-- SQLite:       UPDATE products SET price = (SELECT new_price FROM price_changes
--               WHERE price_changes.product_id = products.product_id);

-- UPDATE with LIMIT (MySQL, SQLite)
-- MySQL:        UPDATE products SET price = 100 WHERE status = 'active' LIMIT 1;
-- SQLite:       UPDATE products SET price = 100 WHERE rowid IN
--               (SELECT rowid FROM products WHERE status = 'active' LIMIT 1);

-- Verify results
SELECT * FROM products ORDER BY product_id;

-- Cleanup
DROP TABLE IF EXISTS price_changes;
DROP TABLE IF EXISTS products;
