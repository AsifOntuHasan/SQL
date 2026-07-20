-- ============================================================
-- 009: INSERT - various INSERT techniques
-- Single row, multi-row, SELECT INTO, INSERT INTO SELECT
-- ============================================================

CREATE TABLE IF NOT EXISTS departments (
    dept_id     INT PRIMARY KEY,
    dept_name   VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id      INT PRIMARY KEY,
    name        VARCHAR(100),
    salary      DECIMAL(10,2),
    dept_id     INT,
    hire_date   DATE
);

-- Single row INSERT
INSERT INTO departments (dept_id, dept_name) VALUES (1, 'Engineering');
INSERT INTO departments (dept_id, dept_name) VALUES (2, 'Marketing');

-- Multi-row INSERT (ANSI standard)
INSERT INTO employees (emp_id, name, salary, dept_id, hire_date) VALUES
(1, 'Alice',   60000, 1, '2024-01-15'),
(2, 'Bob',     55000, 1, '2024-03-20'),
(3, 'Charlie', 65000, 2, '2024-06-10');

-- INSERT with DEFAULT values
CREATE TABLE IF NOT EXISTS config (
    cfg_id    INT PRIMARY KEY DEFAULT 1,
    cfg_key   VARCHAR(50) UNIQUE,
    cfg_value VARCHAR(100),
    is_active INT DEFAULT 1,
    created   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO config (cfg_key, cfg_value) VALUES ('theme', 'dark');
INSERT INTO config (cfg_key, cfg_value) VALUES ('lang', 'en');

-- INSERT INTO ... SELECT (copy from another table)
CREATE TABLE IF NOT EXISTS employees_backup AS
SELECT * FROM employees WHERE 1=0;  -- creates empty table with same structure

INSERT INTO employees_backup
SELECT * FROM employees WHERE dept_id = 1;

-- SELECT INTO (creates new table, syntax varies)
-- PostgreSQL:   CREATE TABLE temp_dept AS SELECT * FROM departments;
-- MySQL:        CREATE TABLE temp_dept AS SELECT * FROM departments;
-- SQL Server:   SELECT * INTO temp_dept FROM departments;
-- SQLite:       CREATE TABLE temp_dept AS SELECT * FROM departments;

-- INSERT with ON CONFLICT / upsert (PostgreSQL, SQLite, MySQL, SQL Server)
-- PostgreSQL:   INSERT INTO employees VALUES (1, 'Alice', 60000, 1, '2024-01-15')
--               ON CONFLICT (emp_id) DO UPDATE SET name = EXCLUDED.name;
-- MySQL:        INSERT INTO employees VALUES (1, 'Alice', 60000, 1, '2024-01-15')
--               ON DUPLICATE KEY UPDATE name = VALUES(name);
-- SQLite:       INSERT OR REPLACE INTO employees VALUES (1, 'Alice', 60000, 1, '2024-01-15');
-- SQL Server:   MERGE ... (see file 012)

-- Verify
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM employees_backup;

-- Cleanup
DROP TABLE IF EXISTS employees_backup;
DROP TABLE IF EXISTS config;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
