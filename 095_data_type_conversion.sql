-- ============================================================
-- 095: Data Type Conversion - CAST, CONVERT, safe conversion
-- ============================================================

CREATE TABLE IF NOT EXISTS raw_import (
    id          INT PRIMARY KEY,
    string_val  VARCHAR(50),
    int_val     VARCHAR(20),
    dec_val     VARCHAR(20),
    date_val    VARCHAR(30)
);

INSERT INTO raw_import VALUES
(1, 'Hello',    '123',     '45.67',     '2025-01-15'),
(2, 'World',    '456',     '89.10',     '15/01/2025'),
(3, 'Test',     'not_num', '12.34.56',  'invalid-date'),
(4, 'Data',     '789',     NULL,        '2025-03-01');

-- CAST: explicit conversion (ANSI standard)
SELECT id,
       CAST(int_val AS INTEGER) AS int_converted,
       CAST(dec_val AS DECIMAL(10,2)) AS dec_converted,
       CAST(date_val AS DATE) AS date_converted
FROM raw_import
WHERE int_val GLOB '[0-9]*';  -- only rows that are numbers

-- TRY_CAST / TRY_CONVERT (SQL Server, PostgreSQL)
-- SQL Server:  TRY_CAST(int_val AS INTEGER) returns NULL instead of error
-- PostgreSQL:  CAST is strict; use TO_NUMBER with formatting

-- Safe conversion using CASE
SELECT id, string_val,
       CASE WHEN int_val GLOB '[0-9]*' THEN CAST(int_val AS INTEGER) ELSE NULL END AS safe_int,
       CASE WHEN dec_val GLOB '[0-9]*.[0-9]*' THEN CAST(dec_val AS DECIMAL(10,2)) ELSE NULL END AS safe_dec,
       CASE WHEN date_val LIKE '____-__-__' THEN CAST(date_val AS DATE) ELSE NULL END AS safe_date
FROM raw_import;

-- String to date with format
-- PostgreSQL:  TO_DATE('15/01/2025', 'DD/MM/YYYY')
-- SQL Server:  CONVERT(DATE, '15/01/2025', 103)
-- MySQL:       STR_TO_DATE('15/01/2025', '%d/%m/%Y')
-- SQLite:      (no direct format; use SUBSTRING)

-- SQLite date parsing example
SELECT id, date_val,
       CASE
           WHEN date_val LIKE '__/__/____' THEN
               SUBSTRING(date_val, 7, 4) || '-' ||
               SUBSTRING(date_val, 4, 2) || '-' ||
               SUBSTRING(date_val, 1, 2)
           WHEN date_val LIKE '____-__-__' THEN date_val
           ELSE NULL
       END AS normalized_date
FROM raw_import;

-- Implicit conversion risks
SELECT 'The value is: ' || CAST(int_val AS VARCHAR) AS concatenated
FROM raw_import WHERE id = 1;

-- Format numbers with ROUND and CAST
SELECT id,
       CAST(dec_val AS DECIMAL(10,2)) AS exact_dec,
       ROUND(CAST(dec_val AS REAL), 1) AS rounded_1dp
FROM raw_import
WHERE dec_val GLOB '*.*';

-- Cleanup
DROP TABLE IF EXISTS raw_import;
