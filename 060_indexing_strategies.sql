-- ============================================================
-- 060: Indexing Strategies - improving query performance
-- Clustered, covering, filtered, composite indexes
-- ============================================================

CREATE TABLE IF NOT EXISTS orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    order_date   DATE,
    status       VARCHAR(20),
    total_amount DECIMAL(12,2),
    shipping_region VARCHAR(20)
);

-- Insert sample data
INSERT INTO orders VALUES
(1, 101, '2025-01-01', 'completed',  1200, 'North'),
(2, 102, '2025-01-02', 'pending',     300, 'South'),
(3, 101, '2025-02-01', 'shipped',     800, 'North'),
(4, 103, '2025-02-15', 'completed',   550, 'East'),
(5, 101, '2025-03-01', 'pending',     200, 'North'),
(6, 104, '2025-03-10', 'completed',  1500, 'West'),
(100, 105, '2025-04-01', 'cancelled',  100, 'North');

-- Strategy 1: Index for WHERE clause columns
-- Queries filtering by customer_id will benefit
CREATE INDEX idx_orders_customer ON orders(customer_id);

-- Strategy 2: Composite index for multi-column filters
-- Queries filtering by status AND order_date
CREATE INDEX idx_orders_status_date ON orders(status, order_date);

-- Strategy 3: Covering index (includes all needed columns)
-- If you always query order_date, total_amount after filtering by status:
CREATE INDEX idx_orders_covering ON orders(status, order_date) INCLUDE (total_amount);
-- Note: INCLUDE is PostgreSQL, SQL Server 2012+
-- MySQL: Composite index with all needed columns

-- Strategy 4: Index for ORDER BY
-- Avoids sorting if index already orders correctly
CREATE INDEX idx_orders_date_desc ON orders(order_date DESC);

-- Strategy 5: Partial/Filtered index (PostgreSQL, SQLite, SQL Server)
-- Only index rows where status = 'pending'
-- PostgreSQL:   CREATE INDEX idx_pending_orders ON orders(order_date) WHERE status = 'pending';
-- SQLite:       CREATE INDEX idx_pending_orders ON orders(order_date) WHERE status = 'pending';
-- SQL Server:   CREATE INDEX idx_pending_orders ON orders(order_date) WHERE status = 'pending';

-- Strategy 6: Index on expression
-- Queries using UPPER(status) etc.
-- PostgreSQL:   CREATE INDEX idx_orders_upper_status ON orders(UPPER(status));

-- Strategy 7: Clustered index (SQL Server, MySQL)
-- Determines physical order of rows
-- Typically already set on PRIMARY KEY

-- Checking index usage (SQL Server)
-- SELECT * FROM sys.dm_db_index_usage_stats WHERE object_id = OBJECT_ID('orders');

-- PostgreSQL: Check index usage
-- SELECT * FROM pg_stat_user_indexes WHERE relname = 'orders';

-- Over-indexing warning: indexes speed up reads but slow writes
-- Keep indexes targeted to actual query patterns

-- Cleanup
DROP INDEX IF EXISTS idx_orders_customer;
DROP INDEX IF EXISTS idx_orders_status_date;
DROP INDEX IF EXISTS idx_orders_covering;
DROP INDEX IF EXISTS idx_orders_date_desc;
DROP TABLE IF EXISTS orders;
