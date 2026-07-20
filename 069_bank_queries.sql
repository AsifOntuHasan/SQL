-- ============================================================
-- 069: Bank Queries - balances, transactions, loan analysis
-- ============================================================

CREATE TABLE IF NOT EXISTS accounts (
    account_id     INT PRIMARY KEY,
    customer_id    INT,
    account_type   VARCHAR(20),
    balance        DECIMAL(14,2),
    status         VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id    INT PRIMARY KEY,
    first_name     VARCHAR(50),
    last_name      VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id   INT PRIMARY KEY,
    account_id       INT,
    transaction_type VARCHAR(20),
    amount           DECIMAL(14,2),
    transaction_at   TIMESTAMP
);

CREATE TABLE IF NOT EXISTS loans (
    loan_id     INT PRIMARY KEY,
    customer_id INT,
    principal   DECIMAL(14,2),
    balance     DECIMAL(14,2),
    interest_rate DECIMAL(5,3),
    status      VARCHAR(20)
);

INSERT INTO customers VALUES (1, 'Alice', 'Smith'), (2, 'Bob', 'Jones');
INSERT INTO accounts VALUES (101, 1, 'checking', 5000, 'active'), (102, 1, 'savings', 15000, 'active'), (103, 2, 'checking', -200, 'overdrawn');
INSERT INTO transactions VALUES (1, 101, 'deposit', 1000, '2025-01-01'), (2, 101, 'withdrawal', 500, '2025-01-02'), (3, 102, 'deposit', 2000, '2025-01-03');
INSERT INTO loans VALUES (1, 1, 300000, 280000, 4.5, 'active'), (2, 2, 50000, 45000, 6.0, 'active');

-- Account balances with customer info
SELECT c.first_name || ' ' || c.last_name AS customer,
       a.account_type, a.account_id, a.balance, a.status
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
ORDER BY customer, account_type;

-- Total balances per customer
SELECT c.first_name || ' ' || c.last_name AS customer,
       COUNT(a.account_id) AS num_accounts,
       SUM(a.balance) AS total_balance,
       SUM(CASE WHEN a.account_type = 'savings' THEN a.balance ELSE 0 END) AS savings_total,
       SUM(CASE WHEN a.account_type = 'checking' THEN a.balance ELSE 0 END) AS checking_total
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id AND a.status = 'active'
GROUP BY c.customer_id
ORDER BY total_balance DESC;

-- Recent transactions
SELECT a.account_id, a.account_type,
       t.transaction_type, t.amount, t.transaction_at
FROM accounts a
JOIN transactions t ON a.account_id = t.account_id
ORDER BY t.transaction_at DESC
LIMIT 10;

-- Overdrawn accounts
SELECT c.first_name || ' ' || c.last_name AS customer,
       a.account_id, a.account_type, a.balance
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
WHERE a.balance < 0
ORDER BY a.balance;

-- Loan portfolio summary
SELECT status, COUNT(*) AS loan_count,
       SUM(principal) AS total_principal,
       SUM(balance) AS total_outstanding,
       AVG(interest_rate) AS avg_rate
FROM loans
GROUP BY status;

-- Customer full financial picture
SELECT c.first_name || ' ' || c.last_name AS customer,
       COALESCE(SUM(a.balance), 0) AS total_accounts_balance,
       COALESCE(SUM(l.balance), 0) AS total_loan_balance,
       COALESCE(SUM(a.balance), 0) - COALESCE(SUM(l.balance), 0) AS net_worth
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id AND a.status = 'active'
LEFT JOIN loans l ON c.customer_id = l.customer_id AND l.status = 'active'
GROUP BY c.customer_id
ORDER BY net_worth DESC;

-- Daily transaction volume
SELECT DATE(transaction_at) AS day, COUNT(*) AS tx_count, SUM(amount) AS total_volume
FROM transactions
GROUP BY day
ORDER BY day DESC;

-- Cleanup
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
