-- ============================================================
-- 082: Temporal Tables - time-based data versioning
-- System-versioned, application-time period tables
-- Note: Temporal tables are database-specific features
-- ============================================================

-- SQL Server: System-Versioned Temporal Table
/*
CREATE TABLE employees_temp (
    emp_id      INT PRIMARY KEY,
    name        VARCHAR(100),
    salary      DECIMAL(10,2),
    dept_id     INT,
    valid_from  DATETIME2 GENERATED ALWAYS AS ROW START,
    valid_to    DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (valid_from, valid_to)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.employees_history));
*/

-- PostgreSQL: Using triggers and history table (no native temporal)
/*
CREATE TABLE employees_history (LIKE employees);
CREATE OR REPLACE FUNCTION fn_employees_version() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employees_history SELECT OLD.*;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_employees_version
BEFORE UPDATE OR DELETE ON employees
FOR EACH ROW EXECUTE FUNCTION fn_employees_version();
*/

-- MySQL: Use history table approach (similar to PostgreSQL)
-- SQLite: Application-managed versioning

-- Simulated temporal table using effective date ranges
CREATE TABLE IF NOT EXISTS employees (
    emp_id      INT,
    name        VARCHAR(100),
    salary      DECIMAL(10,2),
    dept_id     INT,
    eff_date    DATE NOT NULL,
    end_date    DATE,
    PRIMARY KEY (emp_id, eff_date)
);

INSERT INTO employees VALUES
(1, 'Alice', 75000, 1, '2024-01-01', '2024-06-30'),
(1, 'Alice', 80000, 1, '2024-07-01', '2024-12-31'),
(1, 'Alice', 85000, 2, '2025-01-01', NULL),
(2, 'Bob',   70000, 1, '2024-01-01', NULL);

-- Current state
SELECT * FROM employees WHERE end_date IS NULL;

-- State at a point in time
SELECT * FROM employees
WHERE '2024-08-15' BETWEEN eff_date AND COALESCE(end_date, '9999-12-31');

-- Salary history
SELECT emp_id, name, salary, eff_date, end_date
FROM employees
WHERE emp_id = 1
ORDER BY eff_date;

-- All changes between two dates
SELECT * FROM employees
WHERE eff_date >= '2024-06-01' AND eff_date <= '2025-01-01';

-- Cleanup
DROP TABLE IF EXISTS employees;
