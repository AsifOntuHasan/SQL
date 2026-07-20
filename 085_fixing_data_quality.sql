-- ============================================================
-- 085: Data Quality - cleaning, standardizing, validating
-- ============================================================

CREATE TABLE IF NOT EXISTS dirty_data (
    id          INT PRIMARY KEY,
    name        VARCHAR(100),
    email       VARCHAR(100),
    phone       VARCHAR(30),
    status      VARCHAR(20),
    salary      VARCHAR(20),    -- intentionally string for cleanup demo
    zip_code    VARCHAR(10)
);

INSERT INTO dirty_data VALUES
(1, '  Alice Smith  ', 'ALICE@EXAMPLE.COM', ' (555) 123-4567 ', 'Active', '75000', '10001-1234'),
(2, 'BOB JONES',      'bob@example.com',    '555-987-6543',    'active', '85000.50', '20001'),
(3, 'charlie brown',  'invalid-email',      '111-222-3333',    'InActive', NULL, 'abcde'),
(4, ' Diana '         , 'diana@test.com',   NULL,               'active', 'not_a_number', ' 90210 '),
(5, 'Eve',            'eve@example.com',    '555-111-2222',    'Active', '95000', '12345-6789');

-- Trim whitespace
SELECT id, name, TRIM(name) AS cleaned_name
FROM dirty_data;

-- Standardize case
SELECT id,
       UPPER(TRIM(name)) AS name_upper,
       LOWER(TRIM(email)) AS email_lower,
       INITCAP(TRIM(name)) AS name_proper
FROM dirty_data;
-- Note: INITCAP is PostgreSQL/MySQL; SQL Server uses CONCAT + UPPER(LEFT())
-- SQLite doesn't have INITCAP natively

-- Clean phone numbers (digits only)
SELECT id, phone,
       LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
           COALESCE(phone, ''), ' ', ''), '(', ''), ')', ''), '-', ''), '.', '')) AS phone_digits_only
FROM dirty_data;

-- Standardize status values
SELECT id, status,
       CASE
           WHEN LOWER(TRIM(status)) IN ('active', 'yes', '1') THEN 'active'
           WHEN LOWER(TRIM(status)) IN ('inactive', 'no', '0') THEN 'inactive'
           ELSE 'unknown'
       END AS normalized_status
FROM dirty_data;

-- Validate emails (basic)
SELECT id, email,
       CASE WHEN TRIM(email) LIKE '%@%.%' AND TRIM(email) NOT LIKE '% %' THEN 'Valid'
            ELSE 'Invalid'
       END AS email_valid
FROM dirty_data;

-- Clean salary (handle NULLs, remove non-numeric)
SELECT id, salary,
       CASE
           WHEN salary IS NULL THEN 0
           WHEN TRIM(salary) ~ '^[0-9]+(\.[0-9]+)?$' THEN CAST(TRIM(salary) AS DECIMAL(10,2))
           ELSE NULL
       END AS cleaned_salary,
       COALESCE(CAST(TRIM(salary) AS DECIMAL(10,2)), 0) AS salary_default
FROM dirty_data
WHERE salary NOT LIKE '%[^0-9.]%' OR salary IS NULL;
-- Note: regex validation depends on database

-- Standardize zip codes (5-digit)
SELECT id, zip_code,
       SUBSTRING(TRIM(zip_code), 1, 5) AS zip5,
       CASE
           WHEN LENGTH(TRIM(zip_code)) >= 5 AND TRIM(zip_code) LIKE '[0-9][0-9][0-9][0-9][0-9]%' THEN 'Valid'
           ELSE 'Invalid'
       END AS zip_valid
FROM dirty_data;

-- Cleanup
DROP TABLE IF EXISTS dirty_data;
