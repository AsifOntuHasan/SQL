-- ============================================================
-- 098: Locking Hints and Table Hints
-- Controlling lock behavior for specific queries
-- Note: Syntax is database-specific; shown for SQL Server primarily
-- ============================================================

CREATE TABLE IF NOT EXISTS inventory (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100),
    quantity     INT
);

INSERT INTO inventory VALUES (1, 'Laptop', 10), (2, 'Mouse', 50);

-- SQL Server table hints:
-- SELECT * FROM inventory WITH (NOLOCK)       -- READ UNCOMMITTED (dirty reads)
-- SELECT * FROM inventory WITH (HOLDLOCK)     -- SERIALIZABLE
-- SELECT * FROM inventory WITH (TABLOCK)      -- Table lock
-- SELECT * FROM inventory WITH (PAGLOCK)      -- Page lock
-- SELECT * FROM inventory WITH (ROWLOCK)      -- Row lock (default)
-- SELECT * FROM inventory WITH (UPDLOCK)      -- Update lock
-- SELECT * FROM inventory WITH (XLOCK)        -- Exclusive lock
-- SELECT * FROM inventory WITH (READCOMMITTEDLOCK) -- Use locking instead of snapshot

-- PostgreSQL: LOCK TABLE statement
-- BEGIN;
-- LOCK TABLE inventory IN ACCESS EXCLUSIVE MODE;
-- SELECT * FROM inventory;
-- COMMIT;

-- MySQL: Lock hints
-- SELECT * FROM inventory LOCK IN SHARE MODE;
-- SELECT * FROM inventory FOR UPDATE;

-- PostgreSQL: FOR UPDATE / FOR SHARE
-- BEGIN;
-- SELECT * FROM inventory WHERE product_id = 1 FOR UPDATE;
-- UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 1;
-- COMMIT;

-- SQLite: Immediate/Exclusive transactions
-- BEGIN IMMEDIATE;  -- Starts write transaction without waiting
-- SELECT * FROM inventory;
-- COMMIT;

-- NOWAIT (SQL Server, PostgreSQL)
-- SQL Server: SELECT * FROM inventory WITH (NOWAIT)
-- PostgreSQL: SELECT * FROM inventory FOR UPDATE NOWAIT;

-- Skip locked (PostgreSQL 9.5+, MySQL 8.0+)
-- PostgreSQL: SELECT * FROM inventory FOR UPDATE SKIP LOCKED;
-- MySQL:      SELECT * FROM inventory FOR UPDATE SKIP LOCKED;

SELECT product_name, quantity FROM inventory ORDER BY product_id;

-- Cleanup
DROP TABLE IF EXISTS inventory;
