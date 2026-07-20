-- ============================================================
-- 035: NTILE - dividing rows into equal-sized buckets
-- Useful for percentiles, quartiles, deciles
-- ============================================================

CREATE TABLE IF NOT EXISTS students (
    student_id  INT PRIMARY KEY,
    name        VARCHAR(100),
    score       INT
);

INSERT INTO students VALUES
(1,  'Alice',   95),
(2,  'Bob',     88),
(3,  'Charlie', 72),
(4,  'Diana',   91),
(5,  'Eve',     67),
(6,  'Frank',   85),
(7,  'Grace',   93),
(8,  'Henry',   78),
(9,  'Ivy',     82),
(10, 'Jack',    60),
(11, 'Kate',    74),
(12, 'Leo',     89);

-- NTILE(4): quartiles (4 buckets)
SELECT name, score,
       NTILE(4) OVER (ORDER BY score DESC) AS quartile
FROM students
ORDER BY score DESC;

-- NTILE(5): quintiles (5 buckets)
SELECT name, score,
       NTILE(5) OVER (ORDER BY score DESC) AS quintile
FROM students
ORDER BY score DESC;

-- NTILE(10): deciles (10 buckets)
SELECT name, score,
       NTILE(10) OVER (ORDER BY score DESC) AS decile
FROM students
ORDER BY score DESC;

-- NTILE with PARTITION BY
CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept_id   INT
);
INSERT INTO employees VALUES
(1, 'Alice',   80000, 1),
(2, 'Bob',     90000, 1),
(3, 'Charlie', 70000, 1),
(4, 'Diana',   72000, 2),
(5, 'Eve',     85000, 2),
(6, 'Frank',   65000, 2);

SELECT name, salary, dept_id,
       NTILE(3) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_tier
FROM employees
ORDER BY dept_id, salary DESC;

-- NTILE for equal-sized groups
SELECT name, score,
       NTILE(3) OVER (ORDER BY score DESC) AS group_num,
       CASE NTILE(3) OVER (ORDER BY score DESC)
           WHEN 1 THEN 'High'
           WHEN 2 THEN 'Medium'
           WHEN 3 THEN 'Low'
       END AS performance_group
FROM students
ORDER BY score DESC;

-- Cleanup
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS employees;
