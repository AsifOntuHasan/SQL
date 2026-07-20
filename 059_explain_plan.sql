-- ============================================================
-- 059: EXPLAIN / EXPLAIN ANALYZE - query execution plans
-- Understanding how the database executes queries
-- Note: Syntax and output varies by database
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept_id   INT,
    city      VARCHAR(50),
    hire_date DATE
);

-- Insert sample data (in practice you'd have thousands of rows)
INSERT INTO employees VALUES
(1, 'Alice',   80000, 1, 'NYC', '2020-01-01'),
(2, 'Bob',     75000, 1, 'LA',  '2021-03-15'),
(3, 'Charlie', 65000, 2, 'NYC', '2019-06-20'),
(4, 'Diana',   72000, 2, 'CHI', '2022-01-10'),
(5, 'Eve',     90000, 1, 'LA',  '2018-11-30'),
(100, 'Zoe',   95000, 3, 'NYC', '2020-05-15');

CREATE INDEX IF NOT EXISTS idx_emp_dept ON employees(dept_id);
CREATE INDEX IF NOT EXISTS idx_emp_salary ON employees(salary DESC);
CREATE INDEX IF NOT EXISTS idx_emp_city ON employees(city);

-- EXPLAIN: show query plan without executing
-- PostgreSQL:   EXPLAIN SELECT * FROM employees WHERE dept_id = 1;
-- MySQL:        EXPLAIN SELECT * FROM employees WHERE dept_id = 1;
-- SQL Server:   SET SHOWPLAN_XML ON; SELECT * FROM employees WHERE dept_id = 1;
-- SQLite:       EXPLAIN QUERY PLAN SELECT * FROM employees WHERE dept_id = 1;

-- SQLite EXPLAIN QUERY PLAN examples:
EXPLAIN QUERY PLAN
SELECT * FROM employees WHERE dept_id = 1;

EXPLAIN QUERY PLAN
SELECT name, salary FROM employees WHERE salary > 70000 ORDER BY salary DESC;

EXPLAIN QUERY PLAN
SELECT dept_id, AVG(salary) AS avg_sal
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > 70000;

-- Analyzing query plans with joins
CREATE TABLE IF NOT EXISTS departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50)
);
INSERT INTO departments VALUES (1, 'Engineering'), (2, 'Marketing'), (3, 'Sales');

EXPLAIN QUERY PLAN
SELECT e.name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.city = 'NYC';

-- Tips for reading plans:
-- 1. Look for sequential scans (SCAN) on large tables
-- 2. Missing indexes show as full table scans
-- 3. SEARCH with index is faster than SCAN
-- 4. Look for sort operations that could use indexes

-- Cleanup
DROP INDEX IF EXISTS idx_emp_dept;
DROP INDEX IF EXISTS idx_emp_salary;
DROP INDEX IF EXISTS idx_emp_city;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
