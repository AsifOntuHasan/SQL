-- ============================================================
-- 068: Bank Schema - accounts, transactions, customers, branches
-- Banking system database design
-- ============================================================

CREATE TABLE IF NOT EXISTS branches (
    branch_id   INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    address     TEXT,
    phone       VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    ssn         VARCHAR(11) UNIQUE NOT NULL,
    email       VARCHAR(100),
    phone       VARCHAR(20),
    address     TEXT,
    kyc_status  VARCHAR(20) DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS accounts (
    account_id      INT PRIMARY KEY,
    customer_id     INT NOT NULL,
    branch_id       INT,
    account_type    VARCHAR(20) NOT NULL CHECK (account_type IN ('checking', 'savings', 'credit', 'loan')),
    account_number  VARCHAR(20) UNIQUE NOT NULL,
    balance         DECIMAL(14,2) DEFAULT 0.00,
    interest_rate   DECIMAL(5,3) DEFAULT 0.000,
    status          VARCHAR(20) DEFAULT 'active',
    opened_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id  INT PRIMARY KEY,
    account_id      INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal', 'transfer', 'payment', 'fee')),
    amount          DECIMAL(14,2) NOT NULL CHECK (amount > 0),
    balance_before  DECIMAL(14,2),
    balance_after   DECIMAL(14,2),
    description     VARCHAR(200),
    transaction_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE IF NOT EXISTS transfers (
    transfer_id     INT PRIMARY KEY,
    from_account_id INT NOT NULL,
    to_account_id   INT NOT NULL,
    amount          DECIMAL(14,2) NOT NULL CHECK (amount > 0),
    description     VARCHAR(200),
    transfer_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (to_account_id) REFERENCES accounts(account_id)
);

CREATE TABLE IF NOT EXISTS loans (
    loan_id         INT PRIMARY KEY,
    customer_id     INT NOT NULL,
    account_id      INT,
    loan_type       VARCHAR(50),
    principal       DECIMAL(14,2) NOT NULL,
    interest_rate   DECIMAL(5,3) NOT NULL,
    term_months     INT NOT NULL,
    monthly_payment DECIMAL(10,2),
    balance         DECIMAL(14,2),
    status          VARCHAR(20) DEFAULT 'active',
    issued_at       DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Sample data
INSERT INTO branches VALUES (1, 'Main Branch', '100 Main St, NYC', '555-0001');
INSERT INTO branches VALUES (2, 'West Side', '200 West Ave, LA', '555-0002');
INSERT INTO customers VALUES (1, 'Alice', 'Smith', '111-22-3333', 'alice@bank.com', '555-1001', '123 Oak St', 'verified');
INSERT INTO customers VALUES (2, 'Bob', 'Jones', '444-55-6666', 'bob@bank.com', '555-1002', '456 Elm St', 'verified');
INSERT INTO accounts VALUES (101, 1, 1, 'checking', 'ACC-1001', 5000.00, 0.001, 'active', CURRENT_TIMESTAMP);
INSERT INTO accounts VALUES (102, 1, 1, 'savings', 'ACC-1002', 15000.00, 0.025, 'active', CURRENT_TIMESTAMP);
INSERT INTO accounts VALUES (103, 2, 2, 'checking', 'ACC-1003', 2500.00, 0.001, 'active', CURRENT_TIMESTAMP);
INSERT INTO transactions VALUES (1, 101, 'deposit', 1000, 4000, 5000, 'Salary deposit', CURRENT_TIMESTAMP);
INSERT INTO loans VALUES (1, 1, NULL, 'mortgage', 300000, 4.5, 360, 1520.06, 280000, 'active', '2024-01-15');

SELECT * FROM customers;
SELECT * FROM accounts;
SELECT * FROM transactions;
