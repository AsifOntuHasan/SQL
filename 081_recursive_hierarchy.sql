-- ============================================================
-- 081: Recursive Hierarchies - org charts, category trees
-- ============================================================

-- Category tree (product categories)
CREATE TABLE IF NOT EXISTS categories (
    category_id   INT PRIMARY KEY,
    name          VARCHAR(100),
    parent_id     INT,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

INSERT INTO categories VALUES
(1, 'All Products', NULL),
(2, 'Electronics', 1),
(3, 'Clothing', 1),
(4, 'Computers', 2),
(5, 'Phones', 2),
(6, 'Laptops', 4),
(7, 'Desktops', 4),
(8, 'Smartphones', 5),
(9, 'T-Shirts', 3);

-- Recursive CTE: full category tree
WITH RECURSIVE cat_tree AS (
    -- Anchor: top-level categories
    SELECT category_id, name, parent_id, 0 AS level,
           CAST(name AS VARCHAR(500)) AS path
    FROM categories
    WHERE parent_id = 1

    UNION ALL

    -- Recursive: children
    SELECT c.category_id, c.name, c.parent_id, ct.level + 1,
           CAST(ct.path || ' > ' || c.name AS VARCHAR(500)) AS path
    FROM categories c
    JOIN cat_tree ct ON c.parent_id = ct.category_id
)
SELECT * FROM cat_tree
ORDER BY path;

-- Breadcrumb path to a specific category
WITH RECURSIVE breadcrumb AS (
    SELECT category_id, name, parent_id,
           CAST(name AS VARCHAR(500)) AS path
    FROM categories
    WHERE category_id = 8   -- Smartphones

    UNION ALL

    SELECT c.category_id, c.name, c.parent_id,
           CAST(c.name || ' > ' || b.path AS VARCHAR(500)) AS path
    FROM categories c
    JOIN breadcrumb b ON c.category_id = b.parent_id
)
SELECT path FROM breadcrumb WHERE parent_id IS NULL;

-- All leaf categories (no children)
SELECT c.name, c.category_id
FROM categories c
WHERE NOT EXISTS (
    SELECT 1 FROM categories child WHERE child.parent_id = c.category_id
)
ORDER BY c.name;

-- Count of subcategories
SELECT c.name,
       (SELECT COUNT(*) FROM categories child WHERE child.parent_id = c.category_id) AS direct_children,
       (SELECT COUNT(*) FROM categories) AS total_categories
FROM categories c
WHERE c.parent_id = 1 OR c.parent_id IS NULL
ORDER BY c.name;

-- Org chart using the employee_hierarchy pattern (simplified)
CREATE TABLE IF NOT EXISTS employees (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    manager_id INT
);
INSERT INTO employees VALUES
(1, 'CEO', NULL), (2, 'VP1', 1), (3, 'VP2', 1),
(4, 'MGR1', 2), (5, 'MGR2', 2), (6, 'EMP1', 4), (7, 'EMP2', 5);

WITH RECURSIVE org_tree AS (
    SELECT emp_id, name, manager_id, 0 AS depth,
           CAST(name AS VARCHAR(500)) AS chain
    FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.name, e.manager_id, ot.depth + 1,
           CAST(ot.chain || ' -> ' || e.name AS VARCHAR(500)) AS chain
    FROM employees e JOIN org_tree ot ON e.manager_id = ot.emp_id
)
SELECT * FROM org_tree ORDER BY chain;

-- Cleanup
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS categories;
