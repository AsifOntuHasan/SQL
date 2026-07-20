-- ============================================================
-- 084: Deduplication - finding and removing duplicate rows
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    user_id    INT,
    email      VARCHAR(100),
    name       VARCHAR(100),
    signup_date DATE
);

INSERT INTO users VALUES
(1, 'alice@example.com', 'Alice',   '2025-01-01'),
(2, 'bob@example.com',   'Bob',     '2025-01-02'),
(3, 'alice@example.com', 'Alice',   '2025-01-03'),  -- duplicate email
(4, 'charlie@example.com','Charlie','2025-01-04'),
(5, 'bob@example.com',   'Bob Jr',  '2025-01-05'),  -- duplicate email, different name
(6, 'alice@example.com', 'Alice',   '2025-01-06');  -- another duplicate

-- Find all duplicate emails
SELECT email, COUNT(*) AS occurrence_count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Find duplicate rows (all columns same)
SELECT *, COUNT(*) AS cnt
FROM users
GROUP BY user_id, email, name, signup_date
HAVING COUNT(*) > 1;

-- Show all rows marked with duplicate number
SELECT *,
       ROW_NUMBER() OVER (PARTITION BY email ORDER BY signup_date) AS dup_num
FROM users
ORDER BY email, signup_date;

-- Delete duplicates keeping the earliest (using ROW_NUMBER)
WITH numbered AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY signup_date) AS rn
    FROM users
)
DELETE FROM users
WHERE (user_id, email, name, signup_date) IN (
    SELECT user_id, email, name, signup_date FROM numbered WHERE rn > 1
);
-- Note: SQLite needs rowid; PostgreSQL uses ctid
-- Alternative: Create new table, insert deduped rows, rename

-- Safe approach: keep only the first occurrence
CREATE TABLE IF NOT EXISTS users_deduped AS
SELECT user_id, email, name, signup_date
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY email ORDER BY signup_date) AS rn
    FROM users
) t
WHERE rn = 1;

SELECT * FROM users_deduped ORDER BY user_id;

-- Single-column duplicate detection
SELECT email, COUNT(*) AS count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Cleanup
DROP TABLE IF EXISTS users_deduped;
DROP TABLE IF EXISTS users;
