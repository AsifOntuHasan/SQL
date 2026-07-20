-- ============================================================
-- 052: FOREIGN KEY constraint - referential integrity
-- CASCADE, SET NULL, RESTRICT, NO ACTION
-- ============================================================

-- Parent tables
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    name        VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    name       VARCHAR(100)
);

-- Child table with foreign keys
CREATE TABLE IF NOT EXISTS orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    order_date  DATE,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Foreign key with ON DELETE SET NULL
CREATE TABLE IF NOT EXISTS order_items (
    item_id     INT PRIMARY KEY,
    order_id    INT,
    product_id  INT,
    quantity    INT,
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE SET NULL
);

-- Add foreign key after table creation
CREATE TABLE IF NOT EXISTS reviews (
    review_id   INT PRIMARY KEY,
    product_id  INT,
    rating      INT
);
ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Composite foreign key
CREATE TABLE IF NOT EXISTS inventory (
    location_id INT,
    product_id  INT,
    quantity    INT,
    PRIMARY KEY (location_id, product_id)
);

CREATE TABLE IF NOT EXISTS stock_movements (
    movement_id INT PRIMARY KEY,
    location_id INT,
    product_id  INT,
    change_qty  INT,
    FOREIGN KEY (location_id, product_id)
        REFERENCES inventory(location_id, product_id)
);

-- Disable/Enable constraint (SQL Server, PostgreSQL)
-- PostgreSQL:  ALTER TABLE orders DISABLE TRIGGER ALL;
-- SQL Server:  ALTER TABLE orders NOCHECK CONSTRAINT fk_orders_customer;

-- Verify
INSERT INTO customers VALUES (1, 'Alice');
INSERT INTO products VALUES (1, 'Laptop');
INSERT INTO orders VALUES (101, 1, '2025-01-01');

-- Cleanup
DROP TABLE IF EXISTS stock_movements;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
