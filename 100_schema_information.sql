-- ============================================================
-- 100: Schema Information Queries - metadata, catalog, system tables
-- Querying database structure programmatically
-- ============================================================

-- List all tables (cross-database)
-- PostgreSQL:   SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
-- MySQL:        SELECT table_name FROM information_schema.tables WHERE table_schema = 'dbname';
-- SQL Server:   SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE';
-- SQLite:       SELECT name FROM sqlite_master WHERE type = 'table';

-- SQLite:
SELECT name AS table_name, type AS object_type
FROM sqlite_master
WHERE type IN ('table', 'view', 'index')
ORDER BY type, name;

-- List all columns for a table
-- PostgreSQL:   SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'inventory';
-- MySQL:        SELECT column_name, column_type FROM information_schema.columns WHERE table_name = 'inventory';
-- SQL Server:   SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'inventory';
-- SQLite:       PRAGMA table_info('inventory');

-- SQLite PRAGMA simulation
SELECT 'Table: inventory' AS info;
-- PRAGMA table_info(inventory);  -- returns column info

-- Alternative: use fallback with our own data
CREATE TABLE IF NOT EXISTS inventory (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    quantity     INT DEFAULT 0,
    price        DECIMAL(10,2)
);

-- Get column info (SQLite specific)
SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'inventory';

-- List all indexes
-- PostgreSQL:   SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'inventory';
-- MySQL:        SHOW INDEX FROM inventory;
-- SQL Server:   EXEC sp_helpindex 'inventory';
-- SQLite:       SELECT * FROM sqlite_master WHERE type = 'index' AND tbl_name = 'inventory';

SELECT 'Indexes on inventory:' AS info;
SELECT name AS index_name, sql
FROM sqlite_master
WHERE type = 'index' AND tbl_name = 'inventory';

-- Row count estimation
SELECT 'inventory' AS table_name, COUNT(*) AS row_count FROM inventory;

-- Table size estimation (database-specific)
-- PostgreSQL:   SELECT pg_size_pretty(pg_total_relation_size('inventory'));
-- SQL Server:   EXEC sp_spaceused 'inventory';
-- MySQL:        SELECT table_name, round(((data_length + index_length) / 1024 / 1024), 2) FROM information_schema.tables;

-- List foreign keys
-- SQLite: PRAGMA foreign_key_list('inventory');

SELECT name AS object_name, type AS object_type, sql AS definition
FROM sqlite_master
WHERE sql LIKE '%REFERENCES%';

-- Current database and version info (cross-database)
-- PostgreSQL:   SELECT current_database(), version();
-- MySQL:        SELECT DATABASE(), VERSION();
-- SQL Server:   SELECT DB_NAME(), @@VERSION;
-- SQLite:       SELECT sqlite_version();

SELECT sqlite_version() AS version;

-- Cleanup
DROP TABLE IF EXISTS inventory;
