-- ============================================================
-- 043: UPPER, LOWER, TRIM - case conversion & whitespace cleanup
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    user_id    INT PRIMARY KEY,
    username   VARCHAR(50),
    email      VARCHAR(100),
    bio        TEXT
);

INSERT INTO users VALUES
(1, '  Alice_Smith  ', '  ALICE@EXAMPLE.COM  ', '  Hi, I am Alice!  '),
(2, 'BOB_JONES',      'Bob@Example.com',       '  Hello from Bob  '),
(3, 'charlie_brown',  'CHARLIE@EXAMPLE.com',   'Charlie''s bio here');

-- UPPER: convert to uppercase
SELECT username, UPPER(username) AS upper_name,
       email, UPPER(email) AS upper_email
FROM users;

-- LOWER: convert to lowercase
SELECT username, LOWER(username) AS lower_name,
       email, LOWER(email) AS lower_email
FROM users;

-- TRIM: remove leading and trailing whitespace
SELECT username,
       TRIM(username) AS trimmed_name,
       LENGTH(username) AS orig_len,
       LENGTH(TRIM(username)) AS trimmed_len
FROM users;

-- LTRIM / RTRIM: remove whitespace from one side
SELECT username,
       LTRIM(username) AS left_trimmed,
       RTRIM(username) AS right_trimmed
FROM users;

-- TRIM with specific characters
SELECT '--Hello World!--' AS original,
       TRIM('-' FROM '--Hello World!--') AS trimmed_chars;
-- Note: TRIM with characters syntax:
-- PostgreSQL:    TRIM('-' FROM string)
-- MySQL:         TRIM(LEADING '-' FROM string), TRIM(TRAILING '-'), TRIM(BOTH '-' FROM)
-- SQL Server:    LTRIM(RTRIM(REPLACE(string, '-', ' '))) or uses TRIM (SQL Server 2022+)
-- SQLite:        TRIM(string, '-')

-- Data cleaning: normalize emails
SELECT user_id,
       LOWER(TRIM(email)) AS clean_email
FROM users;

-- Data cleaning: normalize usernames
SELECT user_id,
       LOWER(TRIM(username)) AS clean_username
FROM users;

-- Cleanup
DROP TABLE IF EXISTS users;
