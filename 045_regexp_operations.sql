-- ============================================================
-- 045: REGEXP / REGEXP_LIKE / SIMILAR TO - pattern matching
-- Note: Regular expression support varies by database
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    user_id    INT PRIMARY KEY,
    username   VARCHAR(100),
    email      VARCHAR(100),
    phone      VARCHAR(20)
);

INSERT INTO users VALUES
(1, 'alice_smith',    'alice@example.com',      '555-123-4567'),
(2, 'bob',            'invalid-email',           '555-987-6543'),
(3, 'charlie_brown',  'charlie@test.org',        '123.456.7890'),
(4, 'diana',          'diana@company.co.uk',     '(555) 111-2222'),
(5, 'eve',            'not_an_email',            NULL);

-- PostgreSQL: SIMILAR TO, ~, regexp_matches, regexp_replace
-- MySQL: REGEXP, REGEXP_LIKE, REGEXP_REPLACE, REGEXP_SUBSTR
-- SQL Server: doesn't have built-in regex; uses LIKE or CLR
-- SQLite: REGEXP (requires extension), LIKE, GLOB

-- Valid email pattern (basic)
-- PostgreSQL:
-- SELECT * FROM users WHERE email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

-- MySQL:
-- SELECT * FROM users WHERE email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

-- SQLite:
-- SELECT * FROM users WHERE email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

-- Using LIKE (cross-database compatible)
SELECT * FROM users WHERE email LIKE '%@%.%' AND email NOT LIKE '% %';
SELECT * FROM users WHERE phone LIKE '555-%';

-- MySQL REGEXP examples:
-- SELECT * FROM users WHERE username REGEXP '^[a-z_]+$';
-- SELECT * FROM users WHERE phone REGEXP '^[0-9-(). ]+$';

-- PostgreSQL regexp_replace:
-- SELECT regexp_replace(phone, '[^0-9]', '', 'g') AS digits_only FROM users;

-- Simulate regex extraction with string functions
SELECT email,
       SUBSTRING(email, 1, CHARINDEX('@', email) - 1) AS username_part,
       SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS domain_part
FROM users
WHERE email LIKE '%@%.%';

-- Using CASE for pattern matching
SELECT email,
       CASE WHEN email LIKE '%@%.%' THEN 'Valid format'
            ELSE 'Invalid format'
       END AS email_status
FROM users;

-- Cleanup
DROP TABLE IF EXISTS users;
