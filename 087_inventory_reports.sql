-- ============================================================
-- 087: Inventory Reports - stock levels, turnover, reorder alerts
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
    product_id      INT PRIMARY KEY,
    name            VARCHAR(100),
    category        VARCHAR(50),
    unit_cost       DECIMAL(10,2),
    selling_price   DECIMAL(10,2),
    reorder_level   INT DEFAULT 10,
    reorder_qty     INT DEFAULT 50
);

CREATE TABLE IF NOT EXISTS inventory (
    product_id      INT PRIMARY KEY,
    current_stock   INT NOT NULL DEFAULT 0,
    warehouse_location VARCHAR(50),
    last_count_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS inventory_movements (
    movement_id     INT PRIMARY KEY,
    product_id      INT NOT NULL,
    movement_type   VARCHAR(20) CHECK (movement_type IN ('in', 'out', 'adjustment')),
    quantity        INT NOT NULL,
    movement_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference       VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products VALUES
(1, 'Laptop',   'Electronics', 800,  1200, 5,  10),
(2, 'Mouse',    'Electronics', 10,    25, 20, 100),
(3, 'Keyboard', 'Electronics', 30,    75, 10,  30),
(4, 'Desk',     'Furniture',   250,  450, 3,   5),
(5, 'Chair',    'Furniture',   150,  250, 5,  10),
(6, 'Monitor',  'Electronics', 200,  350, 5,  10);

INSERT INTO inventory VALUES
(1, 8,  'Aisle-1',  '2025-01-15'),
(2, 50, 'Aisle-2',  '2025-01-15'),
(3, 25, 'Aisle-1',  '2025-01-15'),
(4, 2,  'Aisle-3',  '2025-01-15'),
(5, 12, 'Aisle-3',  '2025-01-15'),
(6, 3,  'Aisle-1',  '2025-01-15');

INSERT INTO inventory_movements VALUES
(1, 1, 'out', 2, '2025-01-16', 'Sale #101'),
(2, 2, 'in', 100, '2025-01-17', 'Purchase Order #500'),
(3, 4, 'out', 1, '2025-01-18', 'Sale #102');

-- Current stock levels
SELECT p.name, p.category, i.current_stock, i.warehouse_location,
       p.reorder_level, (p.reorder_level - i.current_stock) AS deficit,
       CASE WHEN i.current_stock <= p.reorder_level THEN 'ORDER' ELSE 'OK' END AS action
FROM products p
JOIN inventory i ON p.product_id = i.product_id
ORDER BY current_stock ASC;

-- Stock value
SELECT p.category,
       SUM(i.current_stock * p.unit_cost) AS inventory_value_cost,
       SUM(i.current_stock * p.selling_price) AS inventory_value_retail,
       SUM(i.current_stock * (p.selling_price - p.unit_cost)) AS potential_profit
FROM products p
JOIN inventory i ON p.product_id = i.product_id
GROUP BY p.category
ORDER BY inventory_value_cost DESC;

-- Movement history
SELECT p.name, im.movement_type, im.quantity, im.movement_date, im.reference
FROM inventory_movements im
JOIN products p ON im.product_id = p.product_id
ORDER BY im.movement_date DESC;

-- Reorder report (items below reorder level)
SELECT p.name, p.category, i.current_stock, p.reorder_level, p.reorder_qty,
       (p.reorder_qty - i.current_stock) AS suggested_order_qty
FROM products p
JOIN inventory i ON p.product_id = i.product_id
WHERE i.current_stock <= p.reorder_level
ORDER BY i.current_stock;

-- Slow-moving items (few or no movements, low stock isn't changing)
SELECT p.name, i.current_stock, p.selling_price,
       COUNT(im.movement_id) AS total_movements,
       SUM(CASE WHEN im.movement_type = 'out' THEN im.quantity ELSE 0 END) AS total_out
FROM products p
JOIN inventory i ON p.product_id = i.product_id
LEFT JOIN inventory_movements im ON p.product_id = im.product_id
GROUP BY p.product_id
ORDER BY total_out, i.current_stock;

-- Inventory turnover (simplified: out-movements / avg stock)
SELECT p.name,
       COALESCE(SUM(CASE WHEN im.movement_type = 'out' THEN im.quantity ELSE 0 END), 0) AS units_sold,
       i.current_stock,
       CASE WHEN i.current_stock > 0
            THEN ROUND(COALESCE(SUM(CASE WHEN im.movement_type = 'out' THEN im.quantity ELSE 0 END), 0) * 1.0 / i.current_stock, 2)
            ELSE NULL
       END AS turnover_ratio
FROM products p
JOIN inventory i ON p.product_id = i.product_id
LEFT JOIN inventory_movements im ON p.product_id = im.product_id
GROUP BY p.product_id;

-- Cleanup
DROP TABLE IF EXISTS inventory_movements;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS products;
