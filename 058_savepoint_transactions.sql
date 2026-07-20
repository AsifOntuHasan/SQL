-- ============================================================
-- 058: SAVEPOINT - partial rollback within transactions
-- Note: Syntax varies, but all major DBs support SAVEPOINT
-- ============================================================

CREATE TABLE IF NOT EXISTS accounts (
    account_id INT PRIMARY KEY,
    owner      VARCHAR(100),
    balance    DECIMAL(12,2)
);

CREATE TABLE IF NOT EXISTS transaction_log (
    log_id      INT PRIMARY KEY,
    account_id  INT,
    change      DECIMAL(12,2),
    description VARCHAR(200)
);

INSERT INTO accounts VALUES
(1, 'Alice', 1000.00),
(2, 'Bob',   500.00),
(3, 'Charlie', 300.00);

-- SQLite / PostgreSQL / MySQL style savepoints
BEGIN TRANSACTION;

    INSERT INTO transaction_log VALUES (1, 1, -200, 'Transfer to Bob');
    UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;

    SAVEPOINT after_alice_debit;

    INSERT INTO transaction_log VALUES (2, 2, +200, 'Transfer from Alice');
    UPDATE accounts SET balance = balance + 200 WHERE account_id = 2;

    -- Problem! Let's undo just the Bob update
    ROLLBACK TO SAVEPOINT after_alice_debit;

    -- Now try a different transfer
    INSERT INTO transaction_log VALUES (3, 3, +200, 'Transfer from Alice');
    UPDATE accounts SET balance = balance + 200 WHERE account_id = 3;

COMMIT;

-- Verify: Alice lost 200, Charlie gained 200, Bob unchanged
SELECT * FROM accounts ORDER BY account_id;
SELECT * FROM transaction_log;

-- Nested savepoints
BEGIN TRANSACTION;
    UPDATE accounts SET balance = balance - 50 WHERE account_id = 1;
    SAVEPOINT sp1;
        UPDATE accounts SET balance = balance - 30 WHERE account_id = 2;
        SAVEPOINT sp2;
            UPDATE accounts SET balance = balance + 80 WHERE account_id = 3;
        -- Oops, wrong. Rollback to sp2
        ROLLBACK TO SAVEPOINT sp2;
        -- Try correct update
        UPDATE accounts SET balance = balance + 80 WHERE account_id = 1;
    RELEASE SAVEPOINT sp1;
COMMIT;

-- Note: RELEASE SAVEPOINT removes the savepoint (but doesn't affect data)
-- Note: You can't COMMIT/ROLLBACK to specific savepoint across transactions

-- Cleanup
DROP TABLE IF EXISTS transaction_log;
DROP TABLE IF EXISTS accounts;
