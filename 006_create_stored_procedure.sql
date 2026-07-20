-- ============================================================
-- 006: CREATE PROCEDURE - stored procedures with parameters
-- Note: Syntax varies significantly by database
-- Comments indicate database-specific syntax where applicable
-- ============================================================

CREATE TABLE IF NOT EXISTS inventory (
    item_id     INT PRIMARY KEY,
    item_name   VARCHAR(100),
    quantity    INT,
    reorder_level INT DEFAULT 10
);

INSERT INTO inventory VALUES
(1, 'Widget A', 100, 20),
(2, 'Widget B',   5, 10),
(3, 'Widget C',  50, 15);

-- SQL Server / PostgreSQL (plpgsql) style
-- PostgreSQL version:
/*
CREATE OR REPLACE FUNCTION sp_get_low_stock(threshold INT)
RETURNS TABLE(item_id INT, item_name VARCHAR, quantity INT) AS $$
BEGIN
    RETURN QUERY SELECT i.item_id, i.item_name, i.quantity
    FROM inventory i WHERE i.quantity <= threshold;
END;
$$ LANGUAGE plpgsql;
*/

-- SQL Server version:
/*
CREATE OR REPLACE PROCEDURE sp_get_low_stock
    @threshold INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT item_id, item_name, quantity
    FROM inventory
    WHERE quantity <= @threshold;
END;
*/

-- MySQL version:
/*
DELIMITER //
CREATE PROCEDURE sp_get_low_stock(IN threshold INT)
BEGIN
    SELECT item_id, item_name, quantity
    FROM inventory
    WHERE quantity <= threshold;
END //
DELIMITER ;
*/

-- SQLite does not support stored procedures (uses functions instead)

-- Generic procedure simulation using a script
SELECT item_id, item_name, quantity
FROM inventory
WHERE quantity <= 10
ORDER BY quantity;

-- Cleanup
DROP TABLE IF EXISTS inventory;
