-- ============================================================
-- 005: CREATE VIEW - virtual tables for encapsulation
-- Simple views, views with joins, updatable views, WITH CHECK OPTION
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    name         VARCHAR(100),
    price        DECIMAL(10,2),
    category     VARCHAR(50),
    active       INT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS sales (
    sale_id      INT PRIMARY KEY,
    product_id   INT REFERENCES products(product_id),
    sale_date    DATE,
    quantity     INT,
    amount       DECIMAL(10,2)
);

INSERT INTO products VALUES
(1, 'Laptop',   1200, 'Electronics', 1),
(2, 'Mouse',      25, 'Electronics', 1),
(3, 'Keyboard',   75, 'Electronics', 0);

INSERT INTO sales VALUES
(1, 1, '2025-01-15', 2, 2400),
(2, 2, '2025-01-16', 5,  125),
(3, 1, '2025-02-01', 1, 1200);

-- Simple view
CREATE OR REPLACE VIEW v_active_products AS
SELECT product_id, name, price, category
FROM products
WHERE active = 1;

-- View with JOIN
CREATE OR REPLACE VIEW v_product_sales AS
SELECT p.name, p.category, s.sale_date, s.quantity, s.amount
FROM products p
JOIN sales s ON p.product_id = s.product_id;

-- Aggregation view
CREATE OR REPLACE VIEW v_category_sales AS
SELECT p.category,
       COUNT(*) AS sale_count,
       SUM(s.amount) AS total_revenue,
       AVG(s.amount) AS avg_sale_amount
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category;

-- WITH CHECK OPTION prevents insert/update that would hide the row
CREATE OR REPLACE VIEW v_cheap_products AS
SELECT product_id, name, price, category
FROM products
WHERE price < 100
WITH CHECK OPTION;

-- Materialized view (PostgreSQL only)
-- CREATE MATERIALIZED VIEW mv_category_totals AS
-- SELECT category, COUNT(*) AS cnt, AVG(price) AS avg_price
-- FROM products
-- GROUP BY category;
-- REFRESH MATERIALIZED VIEW mv_category_totals;

-- Querying a view
SELECT * FROM v_active_products;
SELECT * FROM v_product_sales;
SELECT * FROM v_category_sales;

-- Drop a view
DROP VIEW IF EXISTS v_cheap_products;
DROP VIEW IF EXISTS v_active_products;
DROP VIEW IF EXISTS v_product_sales;
DROP VIEW IF EXISTS v_category_sales;

-- Cleanup
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
