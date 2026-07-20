-- ============================================================
-- 071: Employee Queries - HR analytics, payroll, org structure
-- ============================================================

CREATE TABLE IF NOT EXISTS departments (
    dept_id    INT PRIMARY KEY,
    dept_name  VARCHAR(100),
    manager_id INT,
    budget     DECIMAL(14,2)
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id     INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    salary     DECIMAL(10,2),
    dept_id    INT,
    manager_id INT,
    hire_date  DATE,
    status     VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS payroll (
    payroll_id INT PRIMARY KEY,
    emp_id     INT,
    pay_date   DATE,
    net_pay    DECIMAL(10,2)
);

INSERT INTO departments VALUES (1, 'Engineering', 1, 500000), (2, 'Marketing', 3, 300000);
INSERT INTO employees VALUES (1, 'Alice', 'Smith', 110000, 1, NULL, '2020-01-15', 'active');
INSERT INTO employees VALUES (2, 'Bob', 'Jones', 85000, 1, 1, '2021-03-20', 'active');
INSERT INTO employees VALUES (3, 'Charlie', 'Brown', 65000, 2, NULL, '2022-06-10', 'active');
INSERT INTO employees VALUES (4, 'Diana', 'Wilson', 75000, 1, 1, '2023-01-01', 'active');
INSERT INTO employees VALUES (5, 'Eve', 'Davis', 55000, 2, 3, '2023-02-15', 'on_leave');
INSERT INTO payroll VALUES (1, 1, '2025-01-31', 7166), (2, 2, '2025-01-31', 5333), (3, 3, '2025-01-31', 4666);

-- Department salary summary
SELECT d.dept_name,
       COUNT(e.emp_id) AS employee_count,
       ROUND(AVG(e.salary), 2) AS avg_salary,
       ROUND(MIN(e.salary), 2) AS min_salary,
       ROUND(MAX(e.salary), 2) AS max_salary,
       ROUND(SUM(e.salary), 2) AS total_salary_cost
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id AND e.status = 'active'
GROUP BY d.dept_name
ORDER BY avg_salary DESC;

-- Org hierarchy (manager -> subordinates)
SELECT m.first_name || ' ' || m.last_name AS manager,
       e.first_name || ' ' || e.last_name AS direct_report,
       e.salary, e.hire_date
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
ORDER BY manager, e.last_name;

-- Employees with no manager (top-level)
SELECT first_name || ' ' || last_name AS employee, salary, dept_id
FROM employees
WHERE manager_id IS NULL AND status = 'active';

-- Payroll history
SELECT e.first_name || ' ' || e.last_name AS employee,
       p.pay_date, p.net_pay,
       ROW_NUMBER() OVER (PARTITION BY p.emp_id ORDER BY p.pay_date) AS pay_period_num
FROM payroll p
JOIN employees e ON p.emp_id = e.emp_id
ORDER BY employee, p.pay_date;

-- Tenure analysis
SELECT first_name || ' ' || last_name AS employee,
       hire_date,
       CAST((JULIANDAY('now') - JULIANDAY(hire_date)) / 365.25 AS INTEGER) AS years_employed,
       CASE
           WHEN CAST((JULIANDAY('now') - JULIANDAY(hire_date)) / 365.25 AS INTEGER) >= 5 THEN 'Veteran'
           WHEN CAST((JULIANDAY('now') - JULIANDAY(hire_date)) / 365.25 AS INTEGER) >= 2 THEN 'Mid-Level'
           ELSE 'New'
       END AS tenure_group
FROM employees
WHERE status = 'active'
ORDER BY hire_date;

-- Budget utilization
SELECT d.dept_name, d.budget,
       SUM(CASE WHEN e.status = 'active' THEN e.salary ELSE 0 END) AS salary_cost,
       ROUND(SUM(CASE WHEN e.status = 'active' THEN e.salary ELSE 0 END) / d.budget * 100, 1) AS pct_used
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id
ORDER BY pct_used DESC;

-- Headcount by department and status
SELECT d.dept_name, e.status, COUNT(*) AS count
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name, e.status
ORDER BY d.dept_name, e.status;

-- Cleanup
DROP TABLE IF EXISTS payroll;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
