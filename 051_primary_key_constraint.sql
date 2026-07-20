-- ============================================================
-- 051: PRIMARY KEY constraint - uniquely identifies each row
-- Single column, composite, auto-increment, surrogate vs natural
-- ============================================================

-- Single column PRIMARY KEY
CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price        DECIMAL(10,2)
);

-- Composite PRIMARY KEY (multiple columns)
CREATE TABLE IF NOT EXISTS order_items (
    order_id   INT,
    product_id INT,
    quantity   INT,
    PRIMARY KEY (order_id, product_id)
);

-- PRIMARY KEY with auto-increment
-- PostgreSQL:  product_id SERIAL PRIMARY KEY
-- MySQL:       product_id INT AUTO_INCREMENT PRIMARY KEY
-- SQL Server:  product_id INT IDENTITY(1,1) PRIMARY KEY
-- SQLite:      product_id INTEGER PRIMARY KEY AUTOINCREMENT

-- SQLite auto-increment example:
CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name        VARCHAR(100)
);

-- Named PRIMARY KEY constraint
CREATE TABLE IF NOT EXISTS departments (
    dept_id   INT,
    dept_name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (dept_id)
);

-- Add PRIMARY KEY after table creation
CREATE TABLE IF NOT EXISTS employees (
    emp_id  INT,
    name    VARCHAR(100)
);
ALTER TABLE employees ADD CONSTRAINT pk_employees PRIMARY KEY (emp_id);

-- Drop PRIMARY KEY
-- PostgreSQL:  ALTER TABLE employees DROP CONSTRAINT pk_employees;
-- MySQL:       ALTER TABLE employees DROP PRIMARY KEY;
-- SQL Server:  ALTER TABLE employees DROP CONSTRAINT pk_employees;
-- SQLite:      Can't drop primary key (requires table recreate)

-- Verify constraints
INSERT INTO products VALUES (1, 'Laptop', 1200);
INSERT INTO products VALUES (1, 'Mouse', 25); -- Will fail (duplicate PK)

INSERT INTO order_items VALUES (101, 1, 2);
INSERT INTO order_items VALUES (101, 1, 1); -- Will fail (duplicate composite)

-- Cleanup
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;
