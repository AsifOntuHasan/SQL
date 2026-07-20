-- ============================================================
-- 007: CREATE FUNCTION - scalar & table-valued functions
-- Note: Syntax varies by database
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept_id   INT
);

INSERT INTO employees VALUES
(1, 'Alice',   50000, 10),
(2, 'Bob',     60000, 20),
(3, 'Charlie', 70000, 10);

-- PostgreSQL: Scalar function
/*
CREATE OR REPLACE FUNCTION fn_annual_salary(p_salary DECIMAL)
RETURNS DECIMAL AS $$
BEGIN
    RETURN p_salary * 12;
END;
$$ LANGUAGE plpgsql;
*/

-- PostgreSQL: Table-valued function
/*
CREATE OR REPLACE FUNCTION fn_get_dept_employees(p_dept_id INT)
RETURNS TABLE(emp_id INT, name VARCHAR, salary DECIMAL) AS $$
BEGIN
    RETURN QUERY SELECT e.emp_id, e.name, e.salary
    FROM employees e WHERE e.dept_id = p_dept_id;
END;
$$ LANGUAGE plpgsql;
*/

-- MySQL: Scalar function
/*
DELIMITER //
CREATE FUNCTION fn_annual_salary(p_salary DECIMAL(10,2))
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    RETURN p_salary * 12;
END //
DELIMITER ;
*/

-- SQL Server: Scalar function
/*
CREATE FUNCTION fn_annual_salary(@salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @salary * 12;
END;
*/

-- SQL Server: Inline table-valued function
/*
CREATE FUNCTION fn_get_dept_employees(@dept_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT emp_id, name, salary
    FROM employees
    WHERE dept_id = @dept_id
);
*/

-- SQLite: Scalar function
-- No CREATE FUNCTION; uses built-in or application-defined functions

-- Inline calculation as equivalent
SELECT emp_id, name, salary, salary * 12 AS annual_salary
FROM employees;

SELECT emp_id, name, salary
FROM employees
WHERE dept_id = 10;

-- Cleanup
DROP TABLE IF EXISTS employees;
