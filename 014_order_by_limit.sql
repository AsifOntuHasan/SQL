-- ============================================================
-- 014: ORDER BY & LIMIT / OFFSET / FETCH / TOP
-- Sorting results and limiting rows
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    name         VARCHAR(100),
    price        DECIMAL(10,2),
    category     VARCHAR(50),
    stock_qty    INT
);

INSERT INTO products VALUES
(1, 'Laptop',    1200.00, 'Electronics', 10),
(2, 'Mouse',       25.00, 'Electronics', 50),
(3, 'Keyboard',    75.00, 'Electronics', 30),
(4, 'Monitor',    300.00, 'Electronics',  5),
(5, 'Desk',       450.00, 'Furniture',   20),
(6, 'Chair',      250.00, 'Furniture',   15),
(7, 'Lamp',         50.00, 'Furniture',   0);

-- ORDER BY single column (ascending default)
SELECT * FROM products ORDER BY price;

-- ORDER BY descending
SELECT * FROM products ORDER BY price DESC;

-- ORDER BY multiple columns
SELECT * FROM products ORDER BY category ASC, price DESC;

-- ORDER BY column position (not recommended for production)
SELECT name, price FROM products ORDER BY 2 DESC;

-- ORDER BY with expression
SELECT name, price, price * stock_qty AS inventory_value
FROM products ORDER BY inventory_value DESC;

-- LIMIT / FETCH / TOP (syntax varies)

-- LIMIT (PostgreSQL, MySQL, SQLite)
SELECT * FROM products ORDER BY price DESC LIMIT 3;

-- LIMIT with OFFSET (pagination)
SELECT * FROM products ORDER BY product_id LIMIT 3 OFFSET 2;

-- FETCH FIRST (ANSI standard, PostgreSQL, SQL Server, DB2)
SELECT * FROM products ORDER BY price DESC
FETCH FIRST 3 ROWS ONLY;

-- FETCH with OFFSET (ANSI standard)
SELECT * FROM products ORDER BY product_id
OFFSET 2 ROWS FETCH NEXT 3 ROWS ONLY;

-- TOP (SQL Server)
-- SELECT TOP 3 * FROM products ORDER BY price DESC;

-- TOP with TIES (SQL Server)
-- SELECT TOP 3 WITH TIES * FROM products ORDER BY price DESC;

-- Cleanup
DROP TABLE IF EXISTS products;
