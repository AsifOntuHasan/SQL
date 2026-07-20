-- ============================================================
-- 024: Scalar Subqueries - subquery returning a single value
-- Used in SELECT, WHERE, HAVING clauses
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept_id   INT
);

CREATE TABLE IF NOT EXISTS departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO departments VALUES (1, 'Engineering'), (2, 'Marketing');
INSERT INTO employees VALUES
(1, 'Alice',   80000, 1),
(2, 'Bob',     75000, 1),
(3, 'Charlie', 65000, 2),
(4, 'Diana',   72000, 2);

-- Scalar subquery in SELECT
SELECT e.name, e.salary,
       (SELECT AVG(salary) FROM employees) AS company_avg,
       e.salary - (SELECT AVG(salary) FROM employees) AS diff_from_avg
FROM employees e;

-- Scalar subquery in WHERE
SELECT e.name, e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(salary) FROM employees);

-- Scalar subquery in HAVING
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees);

-- Scalar subquery with multiple values (will error if returns >1 row)
-- This is valid:
SELECT name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- Nested scalar subqueries
SELECT e.name, e.salary,
       (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id) AS dept_avg,
       (SELECT MAX(salary) FROM employees WHERE dept_id = e.dept_id) AS dept_max
FROM employees e;

-- Scalar subquery in ORDER BY
SELECT e.name, e.salary
FROM employees e
ORDER BY (SELECT dept_name FROM departments d WHERE d.dept_id = e.dept_id), e.name;

-- Cleanup
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
