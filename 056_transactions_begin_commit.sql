-- ============================================================
-- 056: Transactions - BEGIN TRAN, COMMIT
-- Atomic operations: all succeed or all roll back
-- ============================================================

CREATE TABLE IF NOT EXISTS accounts (
    account_id INT PRIMARY KEY,
    owner      VARCHAR(100),
    balance    DECIMAL(12,2),
    CONSTRAINT chk_positive CHECK (balance >= 0)
);

INSERT INTO accounts VALUES
(1, 'Alice', 1000.00),
(2, 'Bob',   500.00);

-- Simple transaction: transfer money
BEGIN TRANSACTION;

UPDATE accounts
SET balance = balance - 200
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 200
WHERE account_id = 2;

COMMIT;

-- Verify
SELECT * FROM accounts ORDER BY account_id;

-- Transaction with multiple statements
BEGIN TRANSACTION;

INSERT INTO accounts VALUES (3, 'Charlie', 300.00);

UPDATE accounts
SET balance = balance + 100
WHERE account_id = 3;

-- Check intermediate state (visible only within this transaction in most DBs)
SELECT * FROM accounts WHERE account_id = 3;

COMMIT;

-- Nested transactions (syntax varies)
-- PostgreSQL:  SAVEPOINT / RELEASE SAVEPOINT
-- SQL Server:  supports nested @@TRANCOUNT
-- MySQL:       SAVEPOINT / RELEASE SAVEPOINT
-- SQLite:      SAVEPOINT / RELEASE

BEGIN TRANSACTION;
    UPDATE accounts SET balance = balance - 50 WHERE account_id = 1;

    -- PostgreSQL/MySQL: SAVEPOINT sp1;
    -- SQL Server: SAVE TRANSACTION sp1;

    UPDATE accounts SET balance = balance + 50 WHERE account_id = 2;

    -- PostgreSQL/MySQL: RELEASE SAVEPOINT sp1;
COMMIT;

-- Auto-commit behavior
-- Most databases auto-commit each statement by default
-- BEGIN TRANSACTION disables auto-commit until COMMIT/ROLLBACK

-- Check final state
SELECT * FROM accounts ORDER BY account_id;

-- Cleanup
DROP TABLE IF EXISTS accounts;
