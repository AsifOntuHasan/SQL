-- ============================================================
-- 070: Employee Schema - HR database design
-- Employees, departments, positions, time tracking, benefits
-- ============================================================

CREATE TABLE IF NOT EXISTS departments (
    dept_id     INT PRIMARY KEY,
    dept_name   VARCHAR(100) NOT NULL,
    manager_id  INT,
    location    VARCHAR(100),
    budget      DECIMAL(14,2)
);

CREATE TABLE IF NOT EXISTS positions (
    position_id  INT PRIMARY KEY,
    title        VARCHAR(100) NOT NULL,
    min_salary   DECIMAL(10,2),
    max_salary   DECIMAL(10,2),
    dept_id      INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id       INT PRIMARY KEY,
    first_name   VARCHAR(50) NOT NULL,
    last_name    VARCHAR(50) NOT NULL,
    email        VARCHAR(100) UNIQUE NOT NULL,
    phone        VARCHAR(20),
    hire_date    DATE NOT NULL,
    salary       DECIMAL(10,2) NOT NULL,
    dept_id      INT,
    position_id  INT,
    manager_id   INT,
    status       VARCHAR(20) DEFAULT 'active',
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (position_id) REFERENCES positions(position_id),
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

CREATE TABLE IF NOT EXISTS attendance_records (
    record_id    INT PRIMARY KEY,
    emp_id       INT NOT NULL,
    work_date    DATE NOT NULL,
    clock_in     TIME,
    clock_out    TIME,
    hours_worked DECIMAL(4,1),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE IF NOT EXISTS leave_requests (
    leave_id     INT PRIMARY KEY,
    emp_id       INT NOT NULL,
    leave_type   VARCHAR(20) CHECK (leave_type IN ('vacation', 'sick', 'personal', 'holiday')),
    start_date   DATE NOT NULL,
    end_date     DATE NOT NULL,
    status       VARCHAR(20) DEFAULT 'pending',
    approved_by  INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (approved_by) REFERENCES employees(emp_id)
);

CREATE TABLE IF NOT EXISTS payroll (
    payroll_id   INT PRIMARY KEY,
    emp_id       INT NOT NULL,
    pay_date     DATE NOT NULL,
    base_pay     DECIMAL(10,2),
    overtime     DECIMAL(10,2) DEFAULT 0,
    deductions   DECIMAL(10,2) DEFAULT 0,
    net_pay      DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE IF NOT EXISTS performance_reviews (
    review_id    INT PRIMARY KEY,
    emp_id       INT NOT NULL,
    reviewer_id  INT NOT NULL,
    review_date  DATE,
    rating       INT CHECK (rating >= 1 AND rating <= 5),
    comments     TEXT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (reviewer_id) REFERENCES employees(emp_id)
);

-- Sample data
INSERT INTO departments VALUES (1, 'Engineering', NULL, 'Building A', 500000), (2, 'Marketing', NULL, 'Building B', 300000);
INSERT INTO positions VALUES (1, 'Software Engineer', 70000, 120000, 1), (2, 'Marketing Manager', 60000, 100000, 2);
INSERT INTO employees VALUES (1, 'Alice', 'Smith', 'alice@company.com', '555-2001', '2020-01-15', 110000, 1, 1, NULL, 'active');
INSERT INTO employees VALUES (2, 'Bob', 'Jones', 'bob@company.com', '555-2002', '2021-03-20', 85000, 1, 1, 1, 'active');
INSERT INTO employees VALUES (3, 'Charlie', 'Brown', 'charlie@company.com', '555-2003', '2022-06-10', 65000, 2, 2, NULL, 'active');
UPDATE departments SET manager_id = 1 WHERE dept_id = 1;
UPDATE departments SET manager_id = 3 WHERE dept_id = 2;
INSERT INTO payroll VALUES (1, 1, '2025-01-31', 110000/12, 0, 2000, 110000/12 - 2000);
INSERT INTO attendance_records VALUES (1, 1, '2025-01-15', '08:00', '17:00', 8.0);
INSERT INTO performance_reviews VALUES (1, 2, 1, '2025-01-20', 4, 'Good performance');

SELECT * FROM departments;
SELECT * FROM employees;
