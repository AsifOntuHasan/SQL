-- ============================================================
-- 094: Subquery vs CTE Comparison - same query, different styles
-- Readability, reusability, performance considerations
-- ============================================================

CREATE TABLE IF NOT EXISTS departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept_id   INT
);

INSERT INTO departments VALUES (1, 'Engineering'), (2, 'Marketing'), (3, 'Sales');
INSERT INTO employees VALUES
(1, 'Alice',   80000, 1),
(2, 'Bob',     90000, 1),
(3, 'Charlie', 65000, 2),
(4, 'Diana',   72000, 2),
(5, 'Eve',     60000, 3),
(6, 'Frank',   55000, 3);

-- Approach 1: Subquery in FROM (derived table)
SELECT d.dept_name, dept_stats.avg_salary, dept_stats.emp_count
FROM departments d
JOIN (
    SELECT dept_id,
           AVG(salary) AS avg_salary,
           COUNT(*) AS emp_count
    FROM employees
    GROUP BY dept_id
) dept_stats ON d.dept_id = dept_stats.dept_id
ORDER BY dept_stats.avg_salary DESC;

-- Approach 2: CTE
WITH dept_stats AS (
    SELECT dept_id,
           AVG(salary) AS avg_salary,
           COUNT(*) AS emp_count
    FROM employees
    GROUP BY dept_id
)
SELECT d.dept_name, ds.avg_salary, ds.emp_count
FROM departments d
JOIN dept_stats ds ON d.dept_id = ds.dept_id
ORDER BY ds.avg_salary DESC;

-- Approach 3: Correlated subquery in SELECT (least efficient for large datasets)
SELECT d.dept_name,
       (SELECT AVG(salary) FROM employees e WHERE e.dept_id = d.dept_id) AS avg_salary,
       (SELECT COUNT(*) FROM employees e WHERE e.dept_id = d.dept_id) AS emp_count
FROM departments d
ORDER BY avg_salary DESC;

-- Reusable CTE (used multiple times)
WITH high_earners AS (
    SELECT dept_id, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY dept_id
    HAVING AVG(salary) > 70000
)
SELECT d.dept_name, he.avg_sal,
       (SELECT COUNT(*) FROM employees e WHERE e.dept_id = d.dept_id) AS total_emp
FROM departments d
JOIN high_earners he ON d.dept_id = he.dept_id
WHERE he.avg_sal > (SELECT AVG(salary) FROM employees);

-- Performance note:
-- In many databases, CTE and subquery are optimized to the same plan
-- CTEs improve readability for complex queries and can be recursive
-- Materialized CTEs (PostgreSQL: MATERIALIZED / NOT MATERIALIZED) can differ

-- Cleanup
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
