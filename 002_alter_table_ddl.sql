-- ============================================================
-- 002: ALTER TABLE - ADD, DROP, MODIFY columns & constraints
-- DDL operations for schema evolution
-- ============================================================

-- Create a base table for demonstration
CREATE TABLE IF NOT EXISTS employees (
    emp_id      INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50)
);

INSERT INTO employees VALUES (1, 'John', 'Doe');

-- ADD a new column
ALTER TABLE employees ADD COLUMN email VARCHAR(100);
ALTER TABLE employees ADD COLUMN salary DECIMAL(10,2);
ALTER TABLE employees ADD COLUMN department VARCHAR(50) DEFAULT 'General';
ALTER TABLE employees ADD COLUMN hire_date DATE;

-- MODIFY column type (syntax varies by DB)
-- PostgreSQL:   ALTER TABLE employees ALTER COLUMN salary TYPE DECIMAL(12,2);
-- MySQL:        ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12,2);
-- SQL Server:   ALTER TABLE employees ALTER COLUMN salary DECIMAL(12,2);
-- SQLite:       ALTER TABLE employees ALTER COLUMN salary TYPE DECIMAL(12,2); -- limited support

-- RENAME a column (syntax varies)
-- PostgreSQL:   ALTER TABLE employees RENAME COLUMN department TO dept;
-- MySQL:        ALTER TABLE employees CHANGE department dept VARCHAR(50);
-- SQL Server:   EXEC sp_rename 'employees.department', 'dept', 'COLUMN';
-- SQLite:       ALTER TABLE employees RENAME COLUMN department TO dept;

-- ADD a constraint
ALTER TABLE employees ADD CONSTRAINT chk_salary CHECK (salary >= 0);
ALTER TABLE employees ADD CONSTRAINT uq_employee_email UNIQUE (email);

-- DROP a column
ALTER TABLE employees DROP COLUMN department;

-- DROP a constraint
ALTER TABLE employees DROP CONSTRAINT chk_salary;

-- SET DEFAULT (some DBs)
-- ALTER TABLE employees ALTER COLUMN salary SET DEFAULT 0;

-- DROP DEFAULT (some DBs)
-- ALTER TABLE employees ALTER COLUMN salary DROP DEFAULT;

-- Cleanup
DROP TABLE IF EXISTS employees;
