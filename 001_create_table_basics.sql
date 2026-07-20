-- ============================================================
-- 001: DDL - CREATE TABLE with various column types & constraints
-- Demonstrates: PRIMARY KEY, NOT NULL, DEFAULT, UNIQUE, CHECK
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id   INT             PRIMARY KEY,
    first_name    VARCHAR(50)     NOT NULL,
    last_name     VARCHAR(50)     NOT NULL,
    email         VARCHAR(100)    UNIQUE,
    age           INT             CHECK (age >= 0 AND age <= 120),
    status        VARCHAR(20)     DEFAULT 'active',
    created_at    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    product_id    INT             PRIMARY KEY,
    product_name  VARCHAR(100)    NOT NULL,
    price         DECIMAL(10,2)   CHECK (price >= 0),
    stock_qty     INT             DEFAULT 0,
    category      VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id      INT             PRIMARY KEY,
    customer_id   INT             NOT NULL REFERENCES customers(customer_id),
    order_date    DATE            DEFAULT CURRENT_DATE,
    total_amount  DECIMAL(12,2)   CHECK (total_amount >= 0),
    status        VARCHAR(20)     DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id      INT             NOT NULL REFERENCES orders(order_id),
    product_id    INT             NOT NULL REFERENCES products(product_id),
    quantity      INT             NOT NULL CHECK (quantity > 0),
    unit_price    DECIMAL(10,2)   NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

-- Sample INSERT data
INSERT INTO customers (customer_id, first_name, last_name, email, age, status) VALUES
(1, 'Alice',   'Smith',   'alice@example.com',   30, 'active'),
(2, 'Bob',     'Jones',   'bob@example.com',      25, 'active'),
(3, 'Charlie', 'Brown',   'charlie@example.com',  35, 'inactive');

INSERT INTO products (product_id, product_name, price, stock_qty, category) VALUES
(1, 'Laptop',    1200.00, 10, 'Electronics'),
(2, 'Mouse',       25.00, 50, 'Electronics'),
(3, 'Keyboard',    75.00, 30, 'Electronics');

INSERT INTO orders (order_id, customer_id, order_date, total_amount, status) VALUES
(1, 1, '2025-01-15', 1225.00, 'completed'),
(2, 2, '2025-02-20',   25.00, 'pending'),
(3, 1, '2025-03-10', 1275.00, 'shipped');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00),
(1, 2, 1,   25.00),
(2, 2, 1,   25.00),
(3, 1, 1, 1200.00),
(3, 3, 1,   75.00);
