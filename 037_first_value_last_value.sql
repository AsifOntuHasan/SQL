-- ============================================================
-- 037: FIRST_VALUE & LAST_VALUE - window frame boundary values
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept_id   INT,
    hire_date DATE
);

INSERT INTO employees VALUES
(1,  'Alice',   80000, 1, '2020-01-15'),
(2,  'Bob',     90000, 1, '2019-03-20'),
(3,  'Charlie', 70000, 1, '2021-06-10'),
(4,  'Diana',   72000, 2, '2022-01-01'),
(5,  'Eve',     85000, 2, '2020-09-15'),
(6,  'Frank',   65000, 2, '2023-02-28'),
(7,  'Grace',   95000, 1, '2018-11-30');

-- FIRST_VALUE: first value in the window frame
SELECT name, salary, dept_id,
       FIRST_VALUE(name) OVER (ORDER BY salary DESC) AS highest_paid_name
FROM employees;

-- LAST_VALUE: last value in the window frame (default frame)
-- Note: default frame is RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- This often gives unexpected results for LAST_VALUE!
SELECT name, salary,
       LAST_VALUE(name) OVER (ORDER BY salary DESC) AS last_val_default_frame
FROM employees;

-- LAST_VALUE with explicit frame to get the true last
SELECT name, salary,
       LAST_VALUE(name) OVER (
           ORDER BY salary DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS lowest_paid_name
FROM employees;

-- FIRST_VALUE with PARTITION BY
SELECT name, salary, dept_id,
       FIRST_VALUE(name) OVER (
           PARTITION BY dept_id
           ORDER BY salary DESC
       ) AS top_earner_in_dept
FROM employees;

-- FIRST_VALUE with custom frame
SELECT name, salary, hire_date,
       FIRST_VALUE(salary) OVER (
           ORDER BY hire_date
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS salary_2_prev
FROM employees;

-- NTH_VALUE: get nth value (PostgreSQL, SQL Server, Oracle)
-- SELECT name, salary,
--        NTH_VALUE(name, 2) OVER (ORDER BY salary DESC) AS second_highest
-- FROM employees;

-- Cleanup
DROP TABLE IF EXISTS employees;
