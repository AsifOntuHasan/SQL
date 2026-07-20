-- ============================================================
-- 049: CASE - conditional logic in SQL queries
-- Simple CASE, searched CASE, CASE in SELECT/WHERE/ORDER BY
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept_id   INT,
    rating    INT   -- performance rating 1-5
);

INSERT INTO employees VALUES
(1, 'Alice',   80000, 1, 5),
(2, 'Bob',     75000, 1, 3),
(3, 'Charlie', 65000, 2, 4),
(4, 'Diana',   72000, 2, 2),
(5, 'Eve',     95000, 1, 5),
(6, 'Frank',   55000, 3, 1);

-- Simple CASE: compare one expression
SELECT name, salary,
       CASE dept_id
           WHEN 1 THEN 'Engineering'
           WHEN 2 THEN 'Marketing'
           WHEN 3 THEN 'Sales'
           ELSE 'Unknown'
       END AS department_name
FROM employees;

-- Searched CASE: evaluate conditions
SELECT name, salary,
       CASE
           WHEN salary >= 90000 THEN 'Executive'
           WHEN salary >= 70000 THEN 'Senior'
           WHEN salary >= 60000 THEN 'Mid-Level'
           ELSE 'Junior'
       END AS salary_grade,
       CASE
           WHEN rating >= 4 THEN 'Excellent'
           WHEN rating >= 3 THEN 'Good'
           WHEN rating >= 2 THEN 'Needs Improvement'
           ELSE 'Poor'
       END AS performance
FROM employees
ORDER BY salary DESC;

-- CASE in WHERE clause
SELECT name, salary
FROM employees
WHERE CASE
          WHEN dept_id = 1 THEN salary > 70000
          WHEN dept_id = 2 THEN salary > 60000
          ELSE salary > 50000
      END;

-- CASE in ORDER BY (custom sort)
SELECT name, dept_id, salary
FROM employees
ORDER BY
    CASE dept_id
        WHEN 1 THEN 1
        WHEN 2 THEN 2
        WHEN 3 THEN 3
        ELSE 4
    END,
    salary DESC;

-- CASE with UPDATE
UPDATE employees
SET salary = CASE
    WHEN rating >= 4 THEN salary * 1.15   -- 15% raise
    WHEN rating >= 3 THEN salary * 1.10   -- 10% raise
    WHEN rating >= 2 THEN salary * 1.05   -- 5% raise
    ELSE salary * 1.02                    -- 2% raise
END;

-- CASE with aggregation (pivot-like)
SELECT
    COUNT(*) AS total,
    SUM(CASE WHEN dept_id = 1 THEN 1 ELSE 0 END) AS eng_count,
    SUM(CASE WHEN dept_id = 2 THEN 1 ELSE 0 END) AS mkt_count,
    SUM(CASE WHEN dept_id = 3 THEN 1 ELSE 0 END) AS sales_count
FROM employees;

-- Verify results
SELECT * FROM employees ORDER BY emp_id;

-- Cleanup
DROP TABLE IF EXISTS employees;
