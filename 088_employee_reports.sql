-- ============================================================
-- 088: Employee Reports - HR analytics, headcount, compensation
-- ============================================================

CREATE TABLE IF NOT EXISTS departments (
    dept_id    INT PRIMARY KEY,
    dept_name  VARCHAR(100),
    location   VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id     INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    salary     DECIMAL(10,2),
    dept_id    INT,
    hire_date  DATE,
    status     VARCHAR(20) DEFAULT 'active',
    gender     VARCHAR(10),
    birth_date DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO departments VALUES (1, 'Engineering', 'NYC'), (2, 'Marketing', 'LA'), (3, 'Sales', 'Chicago'), (4, 'HR', 'NYC');
INSERT INTO employees VALUES
(1, 'Alice',   'Smith',   110000, 1, '2020-01-15', 'active',   'F', '1985-03-15'),
(2, 'Bob',     'Jones',    85000, 1, '2021-03-20', 'active',   'M', '1990-07-22'),
(3, 'Charlie', 'Brown',    65000, 2, '2022-06-10', 'active',   'M', '1995-11-05'),
(4, 'Diana',   'Wilson',   75000, 1, '2023-01-01', 'active',   'F', '1988-02-14'),
(5, 'Eve',     'Davis',    55000, 2, '2023-02-15', 'on_leave', 'F', '1992-09-30'),
(6, 'Frank',   'Miller',   95000, 1, '2019-08-01', 'active',   'M', '1982-12-10'),
(7, 'Grace',   'Lee',      70000, 3, '2022-11-01', 'active',   'F', '1993-06-25'),
(8, 'Henry',   'Taylor',   60000, 4, '2023-03-20', 'active',   'M', '1991-04-18');

-- Headcount by department
SELECT d.dept_name, COUNT(e.emp_id) AS total_employees,
       SUM(CASE WHEN e.status = 'active' THEN 1 ELSE 0 END) AS active,
       SUM(CASE WHEN e.status = 'on_leave' THEN 1 ELSE 0 END) AS on_leave
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
ORDER BY total_employees DESC;

-- Salary analysis
SELECT d.dept_name,
       ROUND(AVG(e.salary), 2) AS avg_salary,
       ROUND(MIN(e.salary), 2) AS min_salary,
       ROUND(MAX(e.salary), 2) AS max_salary,
       ROUND(AVG(e.salary) - AVG(AVG(e.salary)) OVER (), 2) AS diff_from_company_avg
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id AND e.status = 'active'
GROUP BY d.dept_name
ORDER BY avg_salary DESC;

-- Salary distribution
SELECT CASE
           WHEN e.salary < 60000 THEN '< 60K'
           WHEN e.salary < 80000 THEN '60-80K'
           WHEN e.salary < 100000 THEN '80-100K'
           ELSE '100K+'
       END AS salary_band,
       COUNT(*) AS employee_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees WHERE status = 'active'), 1) AS pct
FROM employees e
WHERE e.status = 'active'
GROUP BY salary_band
ORDER BY salary_band;

-- Gender diversity
SELECT d.dept_name,
       COUNT(e.emp_id) AS total,
       SUM(CASE WHEN e.gender = 'F' THEN 1 ELSE 0 END) AS female,
       SUM(CASE WHEN e.gender = 'M' THEN 1 ELSE 0 END) AS male,
       ROUND(100.0 * SUM(CASE WHEN e.gender = 'F' THEN 1 ELSE 0 END) / COUNT(*), 1) AS female_pct
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id AND e.status = 'active'
GROUP BY d.dept_name
ORDER BY d.dept_name;

-- Tenure distribution
SELECT CASE
           WHEN CAST((JULIANDAY('now') - JULIANDAY(hire_date)) / 365.25 AS INTEGER) < 1 THEN '< 1 year'
           WHEN CAST((JULIANDAY('now') - JULIANDAY(hire_date)) / 365.25 AS INTEGER) < 3 THEN '1-3 years'
           WHEN CAST((JULIANDAY('now') - JULIANDAY(hire_date)) / 365.25 AS INTEGER) < 5 THEN '3-5 years'
           ELSE '5+ years'
       END AS tenure,
       COUNT(*) AS count,
       ROUND(AVG(salary), 0) AS avg_salary
FROM employees
WHERE status = 'active'
GROUP BY tenure
ORDER BY tenure;

-- Location headcount
SELECT d.location, COUNT(e.emp_id) AS count
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id AND e.status = 'active'
GROUP BY d.location
ORDER BY count DESC;

-- Cleanup
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
