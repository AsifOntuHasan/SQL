-- ============================================================
-- 099: Backup & Restore Concepts
-- Export, import, backup commands (database-specific)
-- ============================================================

-- PostgreSQL backups:
-- pg_dump -h localhost -U username dbname > backup.sql
-- pg_dump -h localhost -U username -F c dbname > backup.dump
-- pg_restore -h localhost -U username -d dbname backup.dump

-- MySQL backups:
-- mysqldump -h localhost -u username -p dbname > backup.sql
-- mysqldump -h localhost -u username -p --all-databases > all.sql
-- mysql -h localhost -u username -p dbname < backup.sql

-- SQL Server backups:
-- BACKUP DATABASE dbname TO DISK = 'C:\backup\dbname.bak';
-- BACKUP DATABASE dbname TO DISK = 'C:\backup\dbname.bak' WITH DIFFERENTIAL;
-- RESTORE DATABASE dbname FROM DISK = 'C:\backup\dbname.bak';

-- SQLite backup:
-- .backup 'C:\backup\data.db'
-- COPY data.db TO data_backup.db (file copy)

-- Export table to CSV (cross-database approaches)
CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    name         VARCHAR(100),
    price        DECIMAL(10,2),
    category     VARCHAR(50)
);

INSERT INTO products VALUES
(1, 'Laptop',  1200, 'Electronics'),
(2, 'Mouse',     25, 'Electronics'),
(3, 'Keyboard',  75, 'Electronics');

-- Simulated export: construct CSV format
SELECT 'product_id,name,price,category'
UNION ALL
SELECT CAST(product_id AS VARCHAR) || ',' ||
       name || ',' ||
       CAST(price AS VARCHAR) || ',' ||
       COALESCE(category, '')
FROM products;

-- Table copy for backup
CREATE TABLE IF NOT EXISTS products_backup AS
SELECT * FROM products;

-- Schema-only backup (CREATE TABLE statements)
-- SQLite: .schema products
-- PostgreSQL: pg_dump --schema-only

-- Verify backup
SELECT * FROM products_backup ORDER BY product_id;

-- Cleanup
DROP TABLE IF EXISTS products_backup;
DROP TABLE IF EXISTS products;
