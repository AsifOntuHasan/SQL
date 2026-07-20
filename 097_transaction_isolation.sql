-- ============================================================
-- 097: Transaction Isolation Levels
-- Controlling concurrency behavior
-- Syntax varies; comments indicate specific database commands
-- ============================================================

CREATE TABLE IF NOT EXISTS inventory (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100),
    quantity     INT
);

INSERT INTO inventory VALUES (1, 'Laptop', 10), (2, 'Mouse', 50);

-- Isolation level basics:
-- READ UNCOMMITTED  - Dirty reads, non-repeatable reads, phantom reads
-- READ COMMITTED    - No dirty reads; non-repeatable reads, phantom reads possible
-- REPEATABLE READ   - No dirty/non-repeatable reads; phantom reads possible
-- SERIALIZABLE      - Full isolation (no concurrency issues)

-- Setting isolation level (per session):

-- SQL Server:
-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- PostgreSQL:
-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- MySQL:
-- SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- SQLite:
-- No SET command; uses SERIALIZABLE by default

-- Example: READ COMMITTED (default in most DBs)
BEGIN TRANSACTION;
    SELECT quantity FROM inventory WHERE product_id = 1;
    -- Other session might change quantity here
    SELECT quantity FROM inventory WHERE product_id = 1;  -- Might see different value
COMMIT;

-- Example: SERIALIZABLE (prevents phantom reads)
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- BEGIN TRANSACTION;
--     SELECT SUM(quantity) FROM inventory;
--     INSERT INTO inventory VALUES (3, 'Keyboard', 30);
-- COMMIT;

-- Snapshot isolation (SQL Server, PostgreSQL)
-- SQL Server: SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
-- PostgreSQL: Uses MVCC; REPEATABLE READ gives snapshot-like behavior

-- Read-only transactions (PostgreSQL)
-- BEGIN TRANSACTION READ ONLY;
--     SELECT * FROM inventory;
-- COMMIT;

-- Checking isolation level
-- SQL Server: SELECT CASE transaction_isolation_level ... FROM sys.dm_exec_sessions WHERE session_id = @@SPID;
-- PostgreSQL: SHOW transaction_isolation;

-- Deadlock prevention:
-- 1. Access resources in consistent order
-- 2. Keep transactions short
-- 3. Use lower isolation levels when possible

SELECT product_name, quantity FROM inventory ORDER BY product_id;

-- Cleanup
DROP TABLE IF EXISTS inventory;
