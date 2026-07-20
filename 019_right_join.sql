-- ============================================================
-- 019: RIGHT JOIN (RIGHT OUTER JOIN) - all right table rows
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS projects (
    project_id   INT PRIMARY KEY,
    project_name VARCHAR(100),
    emp_id       INT
);

INSERT INTO employees VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO projects VALUES
(101, 'Project Alpha',   1),
(102, 'Project Beta',    1),
(103, 'Project Gamma',   2),
(104, 'Project Delta',   4);  -- emp_id 4 doesn't exist in employees

-- RIGHT JOIN: shows all projects, even those without employees
SELECT e.name, p.project_id, p.project_name
FROM employees e
RIGHT JOIN projects p ON e.emp_id = p.emp_id
ORDER BY p.project_id;

-- RIGHT JOIN to find orphan records
SELECT p.project_id, p.project_name
FROM employees e
RIGHT JOIN projects p ON e.emp_id = p.emp_id
WHERE e.emp_id IS NULL;

-- RIGHT JOIN with aggregation
SELECT p.project_name, COUNT(e.emp_id) AS team_size
FROM employees e
RIGHT JOIN projects p ON e.emp_id = p.emp_id
GROUP BY p.project_name
ORDER BY team_size DESC;

-- RIGHT JOIN is less common; typically use LEFT JOIN with reversed tables
-- Equivalent LEFT JOIN:
SELECT e.name, p.project_id, p.project_name
FROM projects p
LEFT JOIN employees e ON e.emp_id = p.emp_id
ORDER BY p.project_id;

-- Cleanup
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS employees;
