-- ============================================================
-- 028: IN / NOT IN - checking membership in a set
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    name         VARCHAR(100),
    category     VARCHAR(50),
    price        DECIMAL(10,2)
);

INSERT INTO products VALUES
(1, 'Laptop',    'Electronics', 1200),
(2, 'Mouse',     'Electronics',   25),
(3, 'Keyboard',  'Electronics',   75),
(4, 'Desk',      'Furniture',    450),
(5, 'Chair',     'Furniture',    250),
(6, 'Monitor',   'Electronics',  300),
(7, 'Lamp',      'Furniture',     50);

-- IN with literal list
SELECT name, category, price
FROM products
WHERE category IN ('Electronics', 'Furniture');

-- NOT IN with literal list
SELECT name, category, price
FROM products
WHERE category NOT IN ('Furniture');

-- IN with subquery
SELECT name, price
FROM products
WHERE product_id IN (
    SELECT product_id FROM order_items
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id   INT,
    product_id INT,
    quantity   INT
);
INSERT INTO order_items VALUES (101, 1, 2), (102, 2, 5), (103, 4, 1);

-- NOT IN with subquery (CAUTION: NULL handling!)
SELECT name, price
FROM products
WHERE product_id NOT IN (
    SELECT product_id FROM order_items WHERE product_id IS NOT NULL
);
-- NULL in subquery result causes NOT IN to return empty set!
-- Safer to use NOT EXISTS

-- IN with multiple columns (tuple comparison)
-- PostgreSQL/MySQL: SELECT * FROM products
-- WHERE (category, price) IN (('Electronics', 25), ('Furniture', 250));

-- IN with JOIN alternative (often more efficient)
SELECT p.name, p.price
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id;

-- IN with aggregate result
SELECT name, price
FROM products
WHERE price IN (
    SELECT MAX(price) FROM products
    UNION
    SELECT MIN(price) FROM products
);

-- IN with large list (performance considerations)
-- For very large IN lists, consider temp table JOIN

-- Cleanup
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS products;
