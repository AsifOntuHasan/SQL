-- ============================================================
-- 057: Transactions - ROLLBACK
-- Undoing changes when something goes wrong
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

-- Rollback after detecting an error
BEGIN TRANSACTION;

UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;

-- Oops! Let's check the balance first
SELECT * FROM accounts;

-- Something went wrong, undo everything
ROLLBACK;

-- Verify rollback: balances restored
SELECT * FROM accounts ORDER BY account_id;

-- Transaction with error handling (pseudo-code, varies by database)
-- PostgreSQL:
-- DO $$
-- BEGIN
--     UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;
--     IF (SELECT balance FROM accounts WHERE account_id = 1) < 0 THEN
--         RAISE EXCEPTION 'Insufficient funds';
--     END IF;
--     UPDATE accounts SET balance = balance + 200 WHERE account_id = 2;
-- EXCEPTION
--     WHEN OTHERS THEN
--         ROLLBACK;
-- END;
-- $$;

-- Conditional rollback
BEGIN TRANSACTION;

UPDATE accounts SET balance = balance - 1000 WHERE account_id = 1;

-- Check if overdrawing
-- In application code, check balance before committing
IF (SELECT balance FROM accounts WHERE account_id = 1) < 0
    ROLLBACK;

COMMIT;

-- Simulated: check if transaction should proceed
SELECT balance,
       CASE WHEN balance >= 500 THEN 'Safe to proceed'
            ELSE 'Insufficient funds - would rollback'
       END AS status
FROM accounts WHERE account_id = 1;

-- Explicit rollback of all changes
BEGIN TRANSACTION;
    UPDATE accounts SET balance = 999999 WHERE account_id = 1;
    UPDATE accounts SET balance = 0 WHERE account_id = 2;
ROLLBACK;

-- Final verification
SELECT * FROM accounts ORDER BY account_id;

-- Cleanup
DROP TABLE IF EXISTS accounts;
