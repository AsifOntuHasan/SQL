-- ============================================================
-- 062: E-commerce Schema - customers, products, orders, payments
-- Real-world online store database design
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id   INT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    phone         VARCHAR(20),
    address       TEXT,
    city          VARCHAR(50),
    state         VARCHAR(50),
    zip_code      VARCHAR(10),
    country       VARCHAR(50) DEFAULT 'USA',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories (
    category_id   INT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    parent_id     INT,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

CREATE TABLE IF NOT EXISTS products (
    product_id    INT PRIMARY KEY,
    name          VARCHAR(200) NOT NULL,
    description   TEXT,
    price         DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    category_id   INT,
    stock_qty     INT NOT NULL DEFAULT 0,
    sku           VARCHAR(50) UNIQUE,
    is_active     INT DEFAULT 1,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE IF NOT EXISTS carts (
    cart_id       INT PRIMARY KEY,
    customer_id   INT NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS cart_items (
    cart_id       INT,
    product_id    INT,
    quantity      INT NOT NULL CHECK (quantity > 0),
    added_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT NOT NULL,
    order_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status        VARCHAR(20) DEFAULT 'pending',
    total_amount  DECIMAL(12,2),
    shipping_address TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id      INT,
    product_id    INT,
    quantity      INT NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id    INT PRIMARY KEY,
    order_id      INT NOT NULL,
    amount        DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(50),
    status        VARCHAR(20) DEFAULT 'pending',
    transaction_id VARCHAR(100),
    paid_at       TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE IF NOT EXISTS reviews (
    review_id     INT PRIMARY KEY,
    product_id    INT NOT NULL,
    customer_id   INT NOT NULL,
    rating        INT CHECK (rating >= 1 AND rating <= 5),
    comment       TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Sample data
INSERT INTO customers VALUES (1, 'Alice', 'Smith', 'alice@ex.com', '555-0100', '123 Main St', 'NYC', 'NY', '10001', 'USA', CURRENT_TIMESTAMP);
INSERT INTO categories VALUES (1, 'Electronics', NULL), (2, 'Laptops', 1), (3, 'Accessories', 1);
INSERT INTO products VALUES (1, 'Laptop Pro', 'High-end laptop', 1299.99, 2, 15, 'LAP-001', 1, CURRENT_TIMESTAMP);
INSERT INTO products VALUES (2, 'Wireless Mouse', 'Bluetooth mouse', 29.99, 3, 100, 'MOU-001', 1, CURRENT_TIMESTAMP);
INSERT INTO orders VALUES (1, 1, CURRENT_TIMESTAMP, 'completed', 1329.98, '123 Main St');
INSERT INTO order_items VALUES (1, 1, 1, 1299.99), (1, 2, 1, 29.99);
INSERT INTO payments VALUES (1, 1, 1329.98, 'credit_card', 'completed', 'TXN-001', CURRENT_TIMESTAMP);

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
