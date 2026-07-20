-- ============================================================
-- 013: SELECT with WHERE clause - filtering rows
-- Comparison operators, logical operators, pattern matching
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id      INT PRIMARY KEY,
    name        VARCHAR(100),
    department  VARCHAR(50),
    salary      DECIMAL(10,2),
    hire_date   DATE,
    is_active   INT
);

INSERT INTO employees VALUES
(1, 'Alice',    'Engineering',  80000, '2020-01-15', 1),
(2, 'Bob',      'Engineering',  75000, '2021-03-20', 1),
(3, 'Charlie',  'Marketing',    65000, '2019-06-10', 1),
(4, 'Diana',    'Marketing',    70000, '2022-01-01', 0),
(5, 'Eve',      'Sales',        60000, '2023-02-14', 1),
(6, 'Frank',    'Sales',        55000, '2023-08-01', 0),
(7, 'Grace',    'Engineering',  90000, '2018-11-30', 1);

-- WHERE with comparisons
SELECT * FROM employees WHERE salary > 70000;
SELECT * FROM employees WHERE department = 'Engineering';
SELECT * FROM employees WHERE hire_date >= '2021-01-01';

-- WHERE with logical operators
SELECT * FROM employees
WHERE department = 'Engineering' AND salary > 75000;

SELECT * FROM employees
WHERE department = 'Sales' OR department = 'Marketing';

SELECT * FROM employees
WHERE NOT is_active = 1;

-- WHERE with BETWEEN
SELECT * FROM employees WHERE salary BETWEEN 60000 AND 80000;

-- WHERE with IN
SELECT * FROM employees WHERE department IN ('Engineering', 'Sales');

-- WHERE with LIKE pattern matching
SELECT * FROM employees WHERE name LIKE 'A%';    -- starts with A
SELECT * FROM employees WHERE name LIKE '%e';    -- ends with e
SELECT * FROM employees WHERE name LIKE '%li%';  -- contains 'li'
SELECT * FROM employees WHERE name LIKE '___';   -- 3 characters (underscore = single char)

-- WHERE with IS NULL / IS NOT NULL
CREATE TABLE IF NOT EXISTS nullable_test AS SELECT * FROM employees WHERE 1=0;
SELECT * FROM employees WHERE department IS NOT NULL;

-- WHERE with comparison to subquery
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Cleanup
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS nullable_test;
