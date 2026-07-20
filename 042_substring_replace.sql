-- ============================================================
-- 042: SUBSTRING & REPLACE - extracting and replacing text
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    product_code VARCHAR(50),
    description  TEXT
);

INSERT INTO products VALUES
(1, 'LAP-001-ELEC',  'High-performance laptop computer'),
(2, 'MOU-002-ELEC',  'Wireless optical mouse'),
(3, 'DSK-001-FURN',  'Oak wood desk with drawers'),
(4, 'CHR-002-FURN',  'Ergonomic office chair'),
(5, 'KBD-003-ELEC',  'Mechanical keyboard RGB');

-- SUBSTRING: extract portion of string
-- SUBSTRING(string FROM start FOR length) -- ANSI
-- SUBSTRING(string, start, length) -- common

SELECT product_code,
       SUBSTRING(product_code, 1, 3) AS prefix,       -- first 3 chars
       SUBSTRING(product_code, 5, 3) AS number_part,   -- chars 5-7
       SUBSTRING(product_code, 9, 4) AS category_code  -- chars 9-12
FROM products;

-- SUBSTRING with position of delimiter
SELECT product_code,
       SUBSTRING(product_code, 1, CHARINDEX('-', product_code) - 1) AS first_part
FROM products;

-- LEFT and RIGHT (shorthand for SUBSTRING)
SELECT product_code,
       LEFT(product_code, 3) AS first_three,
       RIGHT(product_code, 4) AS last_four
FROM products;

-- REPLACE: substitute all occurrences
SELECT description,
       REPLACE(description, ' ', ' | ') AS pipe_separated
FROM products;

SELECT description,
       REPLACE(REPLACE(description, 'a', '@'), 'e', '3') AS leetspeak
FROM products;

-- REPLACE to remove characters
SELECT product_code,
       REPLACE(product_code, '-', '') AS code_no_dashes
FROM products;

-- Nested string functions
SELECT product_code,
       UPPER(LEFT(product_code, 3)) AS code_prefix,
       LOWER(SUBSTRING(product_code, CHARINDEX('-', product_code) + 1, 3)) AS code_mid
FROM products;

-- Cleanup
DROP TABLE IF EXISTS products;
