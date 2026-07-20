-- ============================================================
-- 030: GROUP_CONCAT / STRING_AGG / LISTAGG - string aggregation
-- Note: function name varies by database
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    dept_id   INT
);

INSERT INTO employees VALUES
(1,  'Alice',   1),
(2,  'Bob',     1),
(3,  'Charlie', 1),
(4,  'Diana',   2),
(5,  'Eve',     2),
(6,  'Frank',   3);

CREATE TABLE IF NOT EXISTS departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO departments VALUES
(1, 'Engineering'),
(2, 'Marketing'),
(3, 'Sales');

-- GROUP_CONCAT (MySQL, SQLite)
SELECT d.dept_name,
       GROUP_CONCAT(e.name ORDER BY e.name SEPARATOR ', ') AS employees
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
ORDER BY d.dept_name;

-- STRING_AGG (PostgreSQL, SQL Server 2017+)
-- PostgreSQL: STRING_AGG(e.name, ', ' ORDER BY e.name)
-- SQL Server: STRING_AGG(e.name, ', ') WITHIN GROUP (ORDER BY e.name)

-- LISTAGG (Oracle)
-- LISTAGG(e.name, ', ') WITHIN GROUP (ORDER BY e.name)

-- GROUP_CONCAT with DISTINCT
SELECT d.dept_name,
       GROUP_CONCAT(DISTINCT e.name ORDER BY e.name) AS unique_employees
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- GROUP_CONCAT without grouping (all values)
SELECT GROUP_CONCAT(name ORDER BY name, ', ') AS all_employees
FROM employees;

-- String aggregation with custom separator
SELECT d.dept_name,
       GROUP_CONCAT(e.name, ' | ' ORDER BY e.name) AS employees_pipe
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- Alternative for databases without GROUP_CONCAT: using XML/JSON
-- PostgreSQL:  SELECT json_agg(e.name) ...
-- SQL Server:  SELECT STUFF((SELECT ',' + name ... FOR XML PATH('')), 1, 1, '')
-- MySQL:       SELECT JSON_ARRAYAGG(e.name) ...

-- Cleanup
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
