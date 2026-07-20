-- ============================================================
-- 083: Handling NULLs - detection, replacement, safe operations
-- ============================================================

CREATE TABLE IF NOT EXISTS orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    amount      DECIMAL(10,2),
    discount    DECIMAL(10,2),
    ship_date   DATE
);

INSERT INTO orders VALUES
(1, 101, 1000.00, 50.00,  '2025-01-15'),
(2, 102,  500.00, NULL,   '2025-01-20'),
(3, 103,   NULL,  0.00,   NULL),
(4, 104,  200.00, NULL,   NULL),
(5, NULL,  300.00, 15.00,  '2025-02-01');

-- IS NULL / IS NOT NULL
SELECT * FROM orders WHERE ship_date IS NULL;
SELECT * FROM orders WHERE amount IS NOT NULL;
SELECT * FROM orders WHERE discount IS NULL AND amount IS NOT NULL;

-- COALESCE: first non-null value
SELECT order_id,
       COALESCE(amount, 0) AS amount_with_default,
       COALESCE(discount, 0) AS discount_with_default,
       COALESCE(ship_date, 'Not Shipped') AS ship_status
FROM orders;

-- COALESCE with multiple fallbacks
SELECT COALESCE(amount, discount * 10, 0) AS estimated_amount
FROM orders;

-- NULLIF: returns NULL if values equal
SELECT NULLIF(discount, 0) AS discount_or_null
FROM orders;

-- Safe division (avoid division by zero)
SELECT order_id, amount, discount,
       amount / NULLIF(discount, 0) AS amount_per_discount
FROM orders;

-- NULL handling in aggregations
SELECT COUNT(*) AS all_rows,
       COUNT(amount) AS amount_non_null,
       COUNT(DISTINCT amount) AS unique_amounts,
       COUNT(ship_date) AS shipped_count,
       AVG(COALESCE(amount, 0)) AS avg_include_nulls,
       AVG(amount) AS avg_exclude_nulls
FROM orders;

-- NULL handling in joins
SELECT o.order_id, o.amount, c.customer_name
FROM orders o
LEFT JOIN (SELECT 101 AS customer_id, 'Alice' AS customer_name
           UNION SELECT 102, 'Bob'
           UNION SELECT 103, 'Charlie') c
ON o.customer_id = c.customer_id;

-- NULL handling with CASE
SELECT order_id, amount,
       CASE WHEN amount IS NULL THEN 'Missing'
            WHEN amount > 500 THEN 'High'
            WHEN amount > 100 THEN 'Medium'
            ELSE 'Low'
       END AS amount_category
FROM orders;

-- Filtering NULL vs non-NULL in WHERE
SELECT * FROM orders WHERE amount >= 100;       -- excludes NULLs
SELECT * FROM orders WHERE amount < 1000;        -- excludes NULLs
SELECT * FROM orders WHERE amount IS NULL OR amount = 0;

-- Cleanup
DROP TABLE IF EXISTS orders;
