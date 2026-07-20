-- ============================================================
-- 044: CHARINDEX / PATINDEX / POSITION - finding string positions
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    product_code VARCHAR(100),
    description  TEXT
);

INSERT INTO products VALUES
(1, 'LAP-001-ELEC',  'High-performance laptop with 16GB RAM'),
(2, 'MOU-002-ELEC',  'Wireless mouse; battery life 12 months'),
(3, 'DSK-001-FURN',  'Solid oak desk (size: 60x30 inches)'),
(4, 'CHR-002-FURN',  'Ergonomic chair with lumbar support'),
(5, 'MON-003-ELEC',  '27-inch 4K monitor, USB-C');

-- CHARINDEX / POSITION: find substring position
-- CHARINDEX(substring, string, [start]) -- SQL Server, MySQL
-- POSITION(substring IN string) -- PostgreSQL, SQLite
-- INSTR(string, substring) -- MySQL, Oracle

-- SQL Server / MySQL style:
SELECT product_code,
       CHARINDEX('-', product_code) AS first_dash_pos,
       CHARINDEX('-', product_code, CHARINDEX('-', product_code) + 1) AS second_dash_pos
FROM products;

-- PostgreSQL style:
-- SELECT product_code,
--        POSITION('-' IN product_code) AS first_dash,
--        POSITION('-' IN SUBSTRING(product_code FROM POSITION('-' IN product_code) + 1)) + POSITION('-' IN product_code) AS second_dash
-- FROM products;

-- Extract parts using CHARINDEX
SELECT product_code,
       SUBSTRING(product_code, 1, CHARINDEX('-', product_code) - 1) AS category,
       SUBSTRING(product_code, CHARINDEX('-', product_code) + 1, 3) AS num_part
FROM products;

-- PATINDEX: pattern-based position (SQL Server, PostgreSQL)
-- SQL Server: PATINDEX('%[0-9]%', product_code)
-- PostgreSQL: POSITION('digit')

-- Find first digit position (SQL Server)
-- SELECT product_code, PATINDEX('%[0-9]%', product_code) AS first_digit_pos
-- FROM products;

-- Find position of a keyword
SELECT description,
       CASE WHEN CHARINDEX('RAM', description) > 0 THEN 'Has RAM spec'
            WHEN CHARINDEX('USB', description) > 0 THEN 'Has USB'
            ELSE 'Other'
       END AS category_tag
FROM products;

-- Reverse CHARINDEX to find last occurrence
SELECT product_code,
       LEN(product_code) - CHARINDEX('-', REVERSE(product_code)) + 1 AS last_dash_pos
FROM products;

-- Cleanup
DROP TABLE IF EXISTS products;
