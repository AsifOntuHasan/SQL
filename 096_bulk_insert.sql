-- ============================================================
-- 096: Bulk Insert Patterns - efficient large-scale inserts
-- Note: Bulk insert syntax varies by database
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    user_id     INT PRIMARY KEY,
    username    VARCHAR(50),
    email       VARCHAR(100),
    signup_date DATE,
    is_active   INT DEFAULT 1
);

-- Pattern 1: Multi-row INSERT (ANSI standard, best for small batches)
INSERT INTO users (user_id, username, email, signup_date) VALUES
(1, 'alice',   'alice@ex.com',   '2025-01-01'),
(2, 'bob',     'bob@ex.com',     '2025-01-02'),
(3, 'charlie', 'charlie@ex.com', '2025-01-03');

-- Pattern 2: INSERT INTO ... SELECT (from existing table)
CREATE TABLE IF NOT EXISTS users_archive AS
SELECT * FROM users WHERE 1=0;

INSERT INTO users_archive
SELECT * FROM users WHERE is_active = 1;

-- Pattern 3: Bulk INSERT using UNION ALL (cross-database)
INSERT INTO users (user_id, username, email, signup_date)
SELECT 4, 'diana', 'diana@ex.com', '2025-01-04'
UNION ALL
SELECT 5, 'eve', 'eve@ex.com', '2025-01-05'
UNION ALL
SELECT 6, 'frank', 'frank@ex.com', '2025-01-06';

-- Pattern 4: Using a VALUES constructor (PostgreSQL, MySQL, SQL Server)
-- PostgreSQL: INSERT INTO users VALUES (4, 'diana', 'diana@ex.com', '2025-01-04', 1), (5, 'eve', 'eve@ex.com', '2025-01-05', 1);
-- MySQL:      Same syntax
-- SQL Server: Same syntax (up to 1000 rows)

-- Pattern 5: Bulk INSERT from CSV/file (database-specific)
-- PostgreSQL: COPY users FROM '/path/to/file.csv' DELIMITER ',' CSV HEADER;
-- MySQL:      LOAD DATA INFILE '/path/to/file.csv' INTO TABLE users FIELDS TERMINATED BY ',' IGNORE 1 LINES;
-- SQL Server: BULK INSERT users FROM 'C:\path\to\file.csv' WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');
-- SQLite:     .import --csv /path/to/file.csv users

-- Pattern 6: INSERT transactions for performance
BEGIN TRANSACTION;
    INSERT INTO users (user_id, username, email, signup_date) VALUES (7, 'grace', 'grace@ex.com', '2025-01-07');
    INSERT INTO users (user_id, username, email, signup_date) VALUES (8, 'henry', 'henry@ex.com', '2025-01-08');
    INSERT INTO users (user_id, username, email, signup_date) VALUES (9, 'ivy', 'ivy@ex.com', '2025-01-09');
COMMIT;

-- Verify
SELECT COUNT(*) AS total_users FROM users;
SELECT * FROM users ORDER BY user_id;

-- Cleanup
DROP TABLE IF EXISTS users_archive;
DROP TABLE IF EXISTS users;
