-- ============================================================
-- 034: ROW_NUMBER, RANK, DENSE_RANK - window ranking functions
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
(3, 'Charlie', 90000, 1),
(4, 'Diana',   72000, 2),
(5, 'Eve',     85000, 2),
(6, 'Frank',   65000, 2),
(7, 'Grace',   95000, 1);

-- ROW_NUMBER: unique sequential number (ties broken arbitrarily)
SELECT name, salary, dept_id,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn
FROM employees;

-- RANK: same rank for ties, skips numbers
SELECT name, salary, dept_id,
       RANK() OVER (ORDER BY salary DESC) AS rnk
FROM employees;

-- DENSE_RANK: same rank for ties, no gaps
SELECT name, salary, dept_id,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS drnk
FROM employees;

-- ROW_NUMBER with PARTITION BY
SELECT name, salary, dept_id,
       ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn_in_dept
FROM employees;

-- RANK with PARTITION BY
SELECT name, salary, dept_id,
       RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_rank
FROM employees;

-- Practical: top N per group (e.g., top 2 earners per department)
WITH ranked AS (
    SELECT name, salary, dept_id,
           ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT name, salary, dept_id
FROM ranked
WHERE rn <= 2
ORDER BY dept_id, rn;

-- Comparing ROW_NUMBER, RANK, DENSE_RANK side by side
SELECT name, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
       RANK()       OVER (ORDER BY salary DESC) AS rank,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM employees;

-- Cleanup
DROP TABLE IF EXISTS employees;
