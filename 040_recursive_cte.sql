-- ============================================================
-- 040: Recursive CTEs - hierarchical and tree-structured queries
-- ============================================================

-- Employee hierarchy
CREATE TABLE IF NOT EXISTS employees (
    emp_id      INT PRIMARY KEY,
    name        VARCHAR(100),
    manager_id  INT
);

INSERT INTO employees VALUES
(1, 'CEO',         NULL),
(2, 'VP Eng',      1),
(3, 'VP Mkt',      1),
(4, 'Dev Lead',    2),
(5, 'Developer',   4),
(6, 'Marketer',    3),
(7, 'Junior Dev',  4),
(8, 'Intern',      5);

-- Recursive CTE: org chart (PostgreSQL, MySQL 8+, SQL Server, SQLite 3.8.3+)
WITH RECURSIVE org_chart AS (
    -- Anchor: top-level manager
    SELECT emp_id, name, manager_id, 0 AS level,
           CAST(name AS VARCHAR(500)) AS path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: join employees with their managers
    SELECT e.emp_id, e.name, e.manager_id, oc.level + 1,
           CAST(oc.path || ' -> ' || e.name AS VARCHAR(500)) AS path
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.emp_id
)
SELECT * FROM org_chart
ORDER BY path;

-- Number generation (useful for calendar tables)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;

-- Date range generation
WITH RECURSIVE dates AS (
    SELECT DATE('2025-01-01') AS dt
    UNION ALL
    SELECT DATE(dt, '+1 day') FROM dates WHERE dt < '2025-01-10'
)
SELECT * FROM dates;

-- Recursive CTE: tree path to root (find all ancestors)
WITH RECURSIVE ancestors AS (
    SELECT emp_id, name, manager_id
    FROM employees WHERE emp_id = 5   -- Start from Developer

    UNION ALL

    SELECT e.emp_id, e.name, e.manager_id
    FROM employees e
    JOIN ancestors a ON e.emp_id = a.manager_id
)
SELECT * FROM ancestors;

-- Recursive CTE: all subordinates of a manager
WITH RECURSIVE subordinates AS (
    SELECT emp_id, name, manager_id, 0 AS depth
    FROM employees WHERE emp_id = 2    -- VP Eng

    UNION ALL

    SELECT e.emp_id, e.name, e.manager_id, s.depth + 1
    FROM employees e
    JOIN subordinates s ON e.manager_id = s.emp_id
)
SELECT emp_id, name, depth
FROM subordinates
ORDER BY depth, name;

-- Cleanup
DROP TABLE IF EXISTS employees;
