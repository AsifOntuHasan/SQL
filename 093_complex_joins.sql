-- ============================================================
-- 093: Complex JOINs - advanced join patterns
-- Non-equi joins, range joins, multiple conditions
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept_id   INT
);

CREATE TABLE IF NOT EXISTS salary_brackets (
    bracket_id   INT PRIMARY KEY,
    min_salary   DECIMAL(10,2),
    max_salary   DECIMAL(10,2),
    bracket_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

INSERT INTO employees VALUES (1, 'Alice',   85000, 1), (2, 'Bob',   55000, 2), (3, 'Charlie', 120000, 1), (4, 'Diana',  72000, 2);
INSERT INTO departments VALUES (1, 'Engineering'), (2, 'Marketing');
INSERT INTO salary_brackets VALUES (1, 0, 60000, 'Junior'), (2, 60001, 90000, 'Mid'), (3, 90001, 999999, 'Senior');

-- Non-equi JOIN (range join)
SELECT e.name, e.salary, sb.bracket_name
FROM employees e
JOIN salary_brackets sb
    ON e.salary BETWEEN sb.min_salary AND sb.max_salary
ORDER BY e.salary;

-- Self non-equi JOIN: find salary differences
SELECT e1.name AS emp1, e2.name AS emp2,
       ABS(e1.salary - e2.salary) AS salary_diff
FROM employees e1
JOIN employees e2 ON e1.emp_id < e2.emp_id
WHERE ABS(e1.salary - e2.salary) > 20000
ORDER BY salary_diff DESC;

-- Anti-join (find records without matches)
SELECT e.name, e.dept_id
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

-- Semi-join using EXISTS
SELECT e.name, e.salary
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM departments d
    WHERE d.dept_id = e.dept_id AND d.dept_name = 'Engineering'
);

-- Cross-database date range join
CREATE TABLE IF NOT EXISTS promotions (
    promo_id    INT PRIMARY KEY,
    promo_name  VARCHAR(100),
    start_date  DATE,
    end_date    DATE
);
INSERT INTO promotions VALUES (1, 'Summer Sale', '2025-06-01', '2025-08-31');

CREATE TABLE IF NOT EXISTS orders (
    order_id   INT PRIMARY KEY,
    order_date DATE,
    amount     DECIMAL(10,2)
);
INSERT INTO orders VALUES (1, '2025-07-15', 500), (2, '2025-09-01', 300);

-- Range join: orders made during promotions
SELECT o.order_id, o.order_date, o.amount, p.promo_name
FROM orders o
JOIN promotions p ON o.order_date BETWEEN p.start_date AND p.end_date;

-- Cleanup
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS salary_brackets;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;
