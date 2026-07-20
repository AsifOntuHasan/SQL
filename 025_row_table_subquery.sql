-- ============================================================
-- 025: Row & Table Subqueries - subqueries in FROM, IN, ANY, ALL
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    name         VARCHAR(100),
    price        DECIMAL(10,2),
    category     VARCHAR(50)
);

INSERT INTO products VALUES
(1, 'Laptop',   1200, 'Electronics'),
(2, 'Mouse',      25, 'Electronics'),
(3, 'Keyboard',   75, 'Electronics'),
(4, 'Desk',      450, 'Furniture'),
(5, 'Chair',     250, 'Furniture');

-- Table subquery in FROM (derived table / subquery)
SELECT cat_stats.category, cat_stats.max_price,
       cat_stats.min_price, cat_stats.avg_price
FROM (
    SELECT category,
           MAX(price) AS max_price,
           MIN(price) AS min_price,
           AVG(price) AS avg_price
    FROM products
    GROUP BY category
) AS cat_stats
ORDER BY cat_stats.category;

-- Table subquery with JOIN
SELECT p.name, p.price, p.category, cat_stats.avg_price
FROM products p
JOIN (
    SELECT category, AVG(price) AS avg_price
    FROM products
    GROUP BY category
) cat_stats ON p.category = cat_stats.category
WHERE p.price > cat_stats.avg_price;

-- Row subquery (comparing tuples - PostgreSQL, MySQL, SQLite)
-- SELECT * FROM products
-- WHERE (category, price) = ('Electronics', 1200);

-- Subquery with ANY
SELECT name, price, category
FROM products
WHERE price > ANY (
    SELECT price FROM products WHERE category = 'Furniture'
);

-- Subquery with ALL
SELECT name, price, category
FROM products
WHERE price > ALL (
    SELECT price FROM products WHERE category = 'Furniture'
);

-- Subquery with IN (row set)
SELECT name, price, category
FROM products
WHERE category IN (
    SELECT category FROM products WHERE price > 500
);

-- LATERAL subquery (PostgreSQL, SQL Server, Oracle)
-- SELECT p.name, p.price, ranked.seq
-- FROM products p,
-- LATERAL (SELECT 1 AS seq) ranked;

-- Cleanup
DROP TABLE IF EXISTS products;
