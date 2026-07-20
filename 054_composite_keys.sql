-- ============================================================
-- 054: Composite Keys - primary keys with multiple columns
-- Also composite foreign keys and indexes
-- ============================================================

-- Composite PRIMARY KEY
CREATE TABLE IF NOT EXISTS course_enrollments (
    student_id    INT,
    course_id     INT,
    semester      VARCHAR(10),
    enrollment_date DATE,
    grade         VARCHAR(2),
    PRIMARY KEY (student_id, course_id, semester)
);

-- Composite UNIQUE constraint
CREATE TABLE IF NOT EXISTS room_bookings (
    booking_id  INT PRIMARY KEY,
    room_id     INT,
    booking_date DATE,
    time_slot   VARCHAR(20),
    CONSTRAINT uq_room_slot UNIQUE (room_id, booking_date, time_slot)
);

-- Composite FOREIGN KEY
CREATE TABLE IF NOT EXISTS inventory (
    warehouse_id INT,
    product_id   INT,
    quantity     INT,
    PRIMARY KEY (warehouse_id, product_id)
);

CREATE TABLE IF NOT EXISTS stock_movements (
    movement_id  INT PRIMARY KEY,
    warehouse_id INT,
    product_id   INT,
    change_qty   INT,
    movement_date DATE,
    FOREIGN KEY (warehouse_id, product_id)
        REFERENCES inventory(warehouse_id, product_id)
);

-- Composite INDEX
CREATE INDEX idx_enrollment_lookup
ON course_enrollments(course_id, semester);

-- Sample data
INSERT INTO inventory VALUES (1, 1, 100), (1, 2, 50), (2, 1, 75);
INSERT INTO stock_movements VALUES (1, 1, 1, -5, '2025-01-01');

-- Query using composite key
SELECT i.warehouse_id, i.product_id, i.quantity, sm.change_qty, sm.movement_date
FROM inventory i
LEFT JOIN stock_movements sm
    ON i.warehouse_id = sm.warehouse_id
    AND i.product_id = sm.product_id
ORDER BY i.warehouse_id, i.product_id;

-- Simulate natural key with composite
CREATE TABLE IF NOT EXISTS order_items (
    order_id   INT,
    product_id INT,
    quantity   INT,
    unit_price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id   INT PRIMARY KEY,
    order_date DATE
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    name       VARCHAR(100)
);

INSERT INTO orders VALUES (1, '2025-01-01');
INSERT INTO products VALUES (1, 'Laptop'), (2, 'Mouse');
INSERT INTO order_items VALUES (1, 1, 2, 1200), (1, 2, 1, 25);

-- Composite key JOIN
SELECT o.order_id, p.name, oi.quantity, oi.unit_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- Cleanup
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS stock_movements;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS room_bookings;
DROP TABLE IF EXISTS course_enrollments;
