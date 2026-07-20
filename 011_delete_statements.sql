-- ============================================================
-- 011: DELETE - single row, multi-row, correlated, JOIN deletes
-- ============================================================

CREATE TABLE IF NOT EXISTS logs (
    log_id      INT PRIMARY KEY,
    message     TEXT,
    log_level   VARCHAR(20),
    created_at  DATE
);

CREATE TABLE IF NOT EXISTS archived_logs (
    log_id      INT PRIMARY KEY,
    message     TEXT,
    log_level   VARCHAR(20),
    created_at  DATE
);

INSERT INTO logs VALUES
(1, 'System started',  'INFO',    '2024-01-01'),
(2, 'User login',      'INFO',    '2024-01-02'),
(3, 'Error: timeout',  'ERROR',   '2024-01-03'),
(4, 'Warning: disk',   'WARNING', '2024-01-04'),
(5, 'Debug output',    'DEBUG',   '2024-01-05');

-- DELETE single row
DELETE FROM logs WHERE log_id = 5;

-- DELETE multiple rows
DELETE FROM logs WHERE log_level = 'DEBUG';

-- DELETE all rows (careful!)
-- DELETE FROM logs;

-- DELETE with subquery
DELETE FROM logs
WHERE created_at < (SELECT MAX(created_at) FROM logs);

-- DELETE via JOIN (syntax varies)
-- PostgreSQL:   DELETE FROM logs USING archived_logs
--               WHERE logs.log_id = archived_logs.log_id;
-- MySQL:        DELETE logs FROM logs JOIN archived_logs
--               ON logs.log_id = archived_logs.log_id;
-- SQL Server:   DELETE logs FROM logs JOIN archived_logs
--               ON logs.log_id = archived_logs.log_id;
-- SQLite:       DELETE FROM logs WHERE log_id IN
--               (SELECT logs.log_id FROM logs JOIN archived_logs USING(log_id));

-- DELETE with RETURNING (PostgreSQL)
-- DELETE FROM logs WHERE log_level = 'ERROR' RETURNING *;

-- DELETE with LIMIT (MySQL, SQLite)
-- DELETE FROM logs WHERE log_level = 'INFO' LIMIT 1;

-- TRUNCATE vs DELETE: TRUNCATE is faster, can't be filtered
-- TRUNCATE TABLE logs;

-- Verify remaining rows
SELECT * FROM logs ORDER BY log_id;

-- Cleanup
DROP TABLE IF EXISTS archived_logs;
DROP TABLE IF EXISTS logs;
