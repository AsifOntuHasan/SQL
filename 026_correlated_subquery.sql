-- ============================================================
-- 026: Correlated Subqueries - subquery references outer query
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept_id   INT
);

INSERT INTO employees VALUES
(1, 'Alice',   80000, 1),
(2, 'Bob',     90000, 1),
(3, 'Charlie', 65000, 2),
(4, 'Diana',   72000, 2),
(5, 'Eve',     95000, 1);

-- Correlated subquery: employees earning above their dept average
SELECT e1.name, e1.salary, e1.dept_id
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
)
ORDER BY e1.dept_id, e1.salary DESC;

-- Correlated subquery in SELECT
SELECT e.name, e.salary, e.dept_id,
       (SELECT AVG(salary)
        FROM employees e2
        WHERE e2.dept_id = e.dept_id) AS dept_avg_salary
FROM employees e;

-- Correlated subquery with EXISTS (find departments with high earners)
SELECT DISTINCT d.dept_id, d.dept_name
FROM departments d
WHERE EXISTS (
    SELECT 1 FROM employees e
    WHERE e.dept_id = d.dept_id AND e.salary > 80000
);

CREATE TABLE IF NOT EXISTS departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50)
);
INSERT INTO departments VALUES (1, 'Engineering'), (2, 'Marketing');

-- Correlated subquery: find employees with highest salary in each dept
SELECT e1.name, e1.salary, e1.dept_id
FROM employees e1
WHERE e1.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
)
ORDER BY e1.dept_id;

-- Performance note: correlated subqueries execute once per outer row
-- Can often be rewritten with JOIN/window functions for better performance

-- Cleanup
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
