-- ============================================================
-- 080: Dynamic SQL - building and executing SQL at runtime
-- Note: Syntax varies significantly by database
-- WARNING: Use with caution! SQL injection risk
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    salary    DECIMAL(10,2),
    dept      VARCHAR(50)
);

INSERT INTO employees VALUES
(1, 'Alice',   80000, 'Engineering'),
(2, 'Bob',     75000, 'Engineering'),
(3, 'Charlie', 65000, 'Marketing'),
(4, 'Diana',   72000, 'Marketing');

-- SQL Server: sp_executesql
/*
DECLARE @sql NVARCHAR(MAX);
DECLARE @dept VARCHAR(50) = 'Engineering';
SET @sql = 'SELECT * FROM employees WHERE dept = @dept';
EXEC sp_executesql @sql, N'@dept VARCHAR(50)', @dept;
*/

-- PostgreSQL: EXECUTE
/*
DO $$
DECLARE
    dept_filter VARCHAR := 'Engineering';
    sql_text TEXT;
BEGIN
    sql_text := 'SELECT * FROM employees WHERE dept = $1';
    EXECUTE sql_text USING dept_filter;
END $$;
*/

-- MySQL: Prepared statements
/*
SET @dept = 'Engineering';
PREPARE stmt FROM 'SELECT * FROM employees WHERE dept = ?';
EXECUTE stmt USING @dept;
DEALLOCATE PREPARE stmt;
*/

-- SQLite doesn't have EXECUTE for dynamic SQL directly
-- (use application code or recursive CTEs instead)

-- Dynamic pivot example (conceptual - using a parameter for column list)
-- Instead of dynamic SQL, use CASE-based approach (cross-database compatible)
SELECT dept,
       SUM(CASE WHEN name = 'Alice' THEN salary ELSE 0 END) AS alice_salary,
       SUM(CASE WHEN name = 'Bob' THEN salary ELSE 0 END) AS bob_salary,
       SUM(CASE WHEN name = 'Charlie' THEN salary ELSE 0 END) AS charlie_salary,
       SUM(salary) AS total
FROM employees
GROUP BY dept;

-- For truly dynamic column generation, use application code
-- to build the SQL string, or use database-specific XML/JSON:
-- PostgreSQL: json_object_agg / crosstab
-- MySQL:      GROUP_CONCAT + prepared statements
-- SQL Server: STRING_AGG + sp_executesql

-- Simulated dynamic SQL using CASE (safe, cross-database)
SELECT 'Employee Summary' AS report_type,
       COUNT(*) AS employee_count,
       SUM(salary) AS salary_total,
       AVG(salary) AS salary_avg
FROM employees;

-- Cleanup
DROP TABLE IF EXISTS employees;
