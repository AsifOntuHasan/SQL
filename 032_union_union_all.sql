-- ============================================================
-- 032: UNION & UNION ALL - combining result sets
-- ============================================================

CREATE TABLE IF NOT EXISTS customers_2024 (
    customer_id   INT PRIMARY KEY,
    name          VARCHAR(100),
    email         VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS customers_2025 (
    customer_id   INT PRIMARY KEY,
    name          VARCHAR(100),
    email         VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS archived_orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT,
    order_date    DATE,
    amount        DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS current_orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT,
    order_date    DATE,
    amount        DECIMAL(10,2)
);

INSERT INTO customers_2024 VALUES (1, 'Alice', 'alice@ex.com'), (2, 'Bob', 'bob@ex.com');
INSERT INTO customers_2025 VALUES (2, 'Bob', 'bob@ex.com'), (3, 'Charlie', 'charlie@ex.com');
INSERT INTO archived_orders VALUES (101, 1, '2024-01-15', 1200), (102, 2, '2024-06-20', 500);
INSERT INTO current_orders VALUES (103, 1, '2025-03-10', 800), (104, 3, '2025-04-05', 300);

-- UNION: removes duplicates
SELECT name, email FROM customers_2024
UNION
SELECT name, email FROM customers_2025
ORDER BY name;

-- UNION ALL: keeps duplicates (faster)
SELECT name, email FROM customers_2024
UNION ALL
SELECT name, email FROM customers_2025
ORDER BY name;

-- UNION ALL across different tables with a type discriminator
SELECT 'Archived' AS source, order_id, customer_id, order_date, amount
FROM archived_orders
UNION ALL
SELECT 'Current', order_id, customer_id, order_date, amount
FROM current_orders
ORDER BY order_date;

-- UNION with ORDER BY applies to the final result
SELECT customer_id AS id, name, '2024' AS year
FROM customers_2024
UNION
SELECT customer_id, name, '2025' AS year
FROM customers_2025
ORDER BY id, year;

-- UNION with different column counts (must match)
-- SELECT customer_id, name, email FROM customers_2024
-- UNION
-- SELECT customer_id, name, NULL AS email FROM customers_2025;

-- Combining UNION with WHERE and aggregation
SELECT 'A' AS src, COUNT(*) AS cnt FROM customers_2024
UNION ALL
SELECT 'B', COUNT(*) FROM customers_2025
UNION ALL
SELECT 'Total', (SELECT COUNT(*) FROM customers_2024) + (SELECT COUNT(*) FROM customers_2025);

-- Cleanup
DROP TABLE IF EXISTS current_orders;
DROP TABLE IF EXISTS archived_orders;
DROP TABLE IF EXISTS customers_2025;
DROP TABLE IF EXISTS customers_2024;
