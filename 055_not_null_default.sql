-- ============================================================
-- 055: NOT NULL & DEFAULT constraints
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    user_id        INT PRIMARY KEY,
    username       VARCHAR(50) NOT NULL,
    email          VARCHAR(100) NOT NULL,
    password_hash  VARCHAR(64) NOT NULL,
    first_name     VARCHAR(50),
    last_name      VARCHAR(50),
    age            INT DEFAULT 18,
    is_active      INT DEFAULT 1,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP
);

-- NOT NULL with DEFAULT
CREATE TABLE IF NOT EXISTS products (
    product_id    INT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    price         DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    stock_qty     INT NOT NULL DEFAULT 0,
    description   TEXT,
    status        VARCHAR(20) NOT NULL DEFAULT 'active'
);

-- Adding NOT NULL to existing column
CREATE TABLE IF NOT EXISTS temp (
    id   INT PRIMARY KEY,
    val  VARCHAR(50)
);
ALTER TABLE temp ALTER COLUMN val SET NOT NULL;  -- PostgreSQL
-- MySQL:        ALTER TABLE temp MODIFY COLUMN val VARCHAR(50) NOT NULL;
-- SQL Server:   ALTER TABLE temp ALTER COLUMN val VARCHAR(50) NOT NULL;
-- SQLite:       Can't add NOT NULL (requires table recreate)

-- Adding DEFAULT to existing column
ALTER TABLE temp ALTER COLUMN val SET DEFAULT 'N/A';  -- PostgreSQL
-- MySQL:        ALTER TABLE temp MODIFY COLUMN val VARCHAR(50) DEFAULT 'N/A';
-- SQL Server:   ALTER TABLE temp ADD CONSTRAINT df_temp_val DEFAULT 'N/A' FOR val;

-- DROP DEFAULT
-- PostgreSQL:  ALTER TABLE temp ALTER COLUMN val DROP DEFAULT;
-- MySQL:       ALTER TABLE temp MODIFY COLUMN val VARCHAR(50);
-- SQL Server:  ALTER TABLE temp DROP CONSTRAINT df_temp_val;

-- Verify NOT NULL constraint
INSERT INTO users (user_id, username, email, password_hash) VALUES
(1, 'alice', 'alice@ex.com', 'hash123');
-- INSERT INTO users (user_id, username, email) VALUES (2, NULL, 'bob@ex.com', 'hash456'); -- FAILS

-- Verify DEFAULT values
INSERT INTO users (user_id, username, email, password_hash) VALUES
(2, 'bob', 'bob@ex.com', 'hash456');
SELECT * FROM users WHERE user_id = 2;  -- age=18, is_active=1, created_at populated

-- Cleanup
DROP TABLE IF EXISTS temp;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
