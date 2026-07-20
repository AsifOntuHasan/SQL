-- ============================================================
-- 041: String CONCAT functions - combining strings
-- CONCAT, CONCAT_WS, || operator
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    user_id    INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    city       VARCHAR(50),
    state      VARCHAR(20)
);

INSERT INTO users VALUES
(1, 'Alice',   'Smith',   'New York', 'NY'),
(2, 'Bob',     'Johnson', 'Los Angeles', 'CA'),
(3, 'Charlie', 'Brown',   'Chicago',  'IL');

-- CONCAT (ANSI standard, handles NULLs gracefully)
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM users;

-- CONCAT with multiple strings
SELECT CONCAT(city, ', ', state, ' - ', first_name, ' ', last_name) AS address
FROM users;

-- CONCAT_WS (Concat With Separator - MySQL, PostgreSQL, SQLite)
-- SELECT CONCAT_WS(' ', first_name, last_name) AS full_name FROM users;
-- SELECT CONCAT_WS(', ', city, state) AS location FROM users;

-- || operator (ANSI standard, but NULL handling varies)
SELECT first_name || ' ' || last_name AS full_name
FROM users;
-- NULL || 'any' returns NULL in some databases
-- So use COALESCE: COALESCE(first_name, '') || ' ' || COALESCE(last_name, '')

-- FORMAT for string formatting (SQL Server, PostgreSQL)
-- SELECT FORMAT('%s %s (%s, %s)', first_name, last_name, city, state) AS info
-- FROM users;

-- CONCAT with expressions
SELECT user_id, CONCAT(UPPER(LEFT(last_name, 3)), '-', user_id) AS user_code
FROM users;

-- CONCAT in UPDATE
UPDATE users SET last_name = CONCAT(last_name, ' (Updated)') WHERE user_id = 1;

-- Verify
SELECT * FROM users ORDER BY user_id;

-- Cleanup
DROP TABLE IF EXISTS users;
