-- ============================================================
-- 022: SELF JOIN - joining a table to itself
-- Useful for hierarchies, relationships, comparisons
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    emp_id      INT PRIMARY KEY,
    name        VARCHAR(100),
    manager_id  INT,       -- references emp_id (self-referencing)
    salary      DECIMAL(10,2),
    department  VARCHAR(50)
);

INSERT INTO employees VALUES
(1, 'CEO',        NULL, 200000, 'Executive'),
(2, 'VP Eng',     1,    150000, 'Engineering'),
(3, 'VP Mkt',     1,    140000, 'Marketing'),
(4, 'Dev Lead',   2,    120000, 'Engineering'),
(5, 'Developer',  4,     90000, 'Engineering'),
(6, 'Marketer',   3,     85000, 'Marketing'),
(7, 'Junior Dev', 4,     65000, 'Engineering');

-- Self join: employee with their manager
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
ORDER BY e.emp_id;

-- Self join: find employees who earn more than their manager
SELECT e.name AS employee, e.salary AS emp_salary,
       m.name AS manager, m.salary AS mgr_salary
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- Self join: find employees with same manager (coworkers)
SELECT e1.name AS employee1, e2.name AS employee2, m.name AS manager
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.manager_id AND e1.emp_id < e2.emp_id
JOIN employees m ON e1.manager_id = m.emp_id
ORDER BY manager, employee1;

-- Self join for comparing rows within same table
CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    name       VARCHAR(100),
    price      DECIMAL(10,2),
    category   VARCHAR(50)
);

INSERT INTO products VALUES
(1, 'Laptop',   1200, 'Electronics'),
(2, 'Mouse',      25, 'Electronics'),
(3, 'Keyboard',   75, 'Electronics'),
(4, 'Monitor',   300, 'Electronics');

-- Find product pairs in the same category with different prices
SELECT p1.name AS cheaper, p2.name AS pricier, p1.price, p2.price,
       (p2.price - p1.price) AS diff
FROM products p1
JOIN products p2 ON p1.category = p2.category AND p1.price < p2.price
ORDER BY p1.category, diff;

-- Cleanup
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;
