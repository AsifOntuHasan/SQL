-- ============================================================
-- 004: CREATE INDEX - various index types for performance
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    user_id     INT PRIMARY KEY,
    username    VARCHAR(50),
    email       VARCHAR(100),
    last_login  TIMESTAMP,
    status      VARCHAR(20),
    age         INT,
    city        VARCHAR(50)
);

INSERT INTO users VALUES
(1, 'alice',   'alice@ex.com',  '2025-01-01', 'active',  30, 'NYC'),
(2, 'bob',     'bob@ex.com',    '2025-01-02', 'active',  25, 'LA'),
(3, 'charlie', 'charlie@ex.com','2025-01-03', 'inactive',35, 'Chicago'),
(4, 'diana',   'diana@ex.com',  '2025-01-04', 'active',  28, 'NYC'),
(5, 'eve',     'eve@ex.com',    '2025-01-05', 'active',  22, 'LA');

-- Single-column index
CREATE INDEX idx_users_status ON users(status);

-- Composite (multi-column) index
CREATE INDEX idx_users_city_status ON users(city, status);

-- Unique index
CREATE UNIQUE INDEX idx_users_email ON users(email);

-- Partial index (PostgreSQL, SQLite)
-- WHERE clause: only indexes qualifying rows
-- PostgreSQL:   CREATE INDEX idx_users_active ON users(last_login) WHERE status = 'active';
-- SQLite:       CREATE INDEX idx_users_active ON users(last_login) WHERE status = 'active';

-- Descending index
CREATE INDEX idx_users_last_login_desc ON users(last_login DESC);

-- Full-text index (syntax varies)
-- PostgreSQL:   CREATE INDEX idx_users_username_fts ON users USING gin(to_tsvector('english', username));
-- MySQL:        CREATE FULLTEXT INDEX idx_users_username_fts ON users(username);
-- SQL Server:   CREATE FULLTEXT INDEX ... (requires catalog setup)

-- Clustered index (SQL Server, MySQL)
-- SQL Server:   CREATE CLUSTERED INDEX idx_users_age ON users(age);
-- MySQL:        ALTER TABLE users ADD PRIMARY KEY(user_id); -- PK is clustered

-- Drop an index
DROP INDEX IF EXISTS idx_users_email;

-- Index for expression/function
-- PostgreSQL:   CREATE INDEX idx_users_lname ON users(LOWER(username));
-- SQLite:       CREATE INDEX idx_users_lname ON users(LOWER(username));

-- Cleanup
DROP TABLE IF EXISTS users;
