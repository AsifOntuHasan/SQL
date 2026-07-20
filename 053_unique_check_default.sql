-- ============================================================
-- 053: UNIQUE, CHECK, DEFAULT constraints
-- Data integrity beyond primary keys
-- ============================================================

-- UNIQUE: no duplicate values
CREATE TABLE IF NOT EXISTS users (
    user_id    INT PRIMARY KEY,
    username   VARCHAR(50) UNIQUE,
    email      VARCHAR(100),
    CONSTRAINT uq_users_email UNIQUE (email)
);

-- Multi-column UNIQUE
CREATE TABLE IF NOT EXISTS product_variants (
    variant_id  INT PRIMARY KEY,
    product_id  INT,
    color       VARCHAR(20),
    size        VARCHAR(10),
    CONSTRAINT uq_product_color_size UNIQUE (product_id, color, size)
);

-- CHECK constraint
CREATE TABLE IF NOT EXISTS employees (
    emp_id     INT PRIMARY KEY,
    name       VARCHAR(100),
    age        INT CHECK (age >= 18 AND age <= 120),
    salary     DECIMAL(10,2) CHECK (salary >= 0),
    dept_id    INT,
    CONSTRAINT chk_valid_dept CHECK (dept_id BETWEEN 1 AND 10)
);

-- Named CHECK constraint
CREATE TABLE IF NOT EXISTS accounts (
    account_id INT PRIMARY KEY,
    balance    DECIMAL(12,2),
    status     VARCHAR(20),
    CONSTRAINT chk_positive_balance CHECK (balance >= 0),
    CONSTRAINT chk_valid_status CHECK (status IN ('active', 'inactive', 'frozen'))
);

-- DEFAULT constraint
CREATE TABLE IF NOT EXISTS orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    order_date  DATE DEFAULT CURRENT_DATE,
    status      VARCHAR(20) DEFAULT 'pending',
    priority    INT DEFAULT 3,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CHECK with function call (PostgreSQL, MySQL 8+)
-- CREATE TABLE IF NOT EXISTS products (
--     product_id INT PRIMARY KEY,
--     price DECIMAL(10,2),
--     discounted_price DECIMAL(10,2),
--     CONSTRAINT chk_discount CHECK (discounted_price <= price)
-- );

-- Adding constraints after table creation
CREATE TABLE IF NOT EXISTS temp_table (
    id INT PRIMARY KEY
);
ALTER TABLE temp_table ADD CONSTRAINT uq_temp_id UNIQUE (id);

-- Verify
INSERT INTO users VALUES (1, 'alice', 'alice@ex.com');
-- INSERT INTO users VALUES (2, 'alice', 'bob@ex.com'); -- UNIQUE violation

INSERT INTO accounts VALUES (1, 100, 'active');
-- INSERT INTO accounts VALUES (2, -5, 'active'); -- CHECK violation

-- Cleanup
DROP TABLE IF EXISTS temp_table;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS product_variants;
DROP TABLE IF EXISTS users;
