-- ============================================================
-- 050: COALESCE, NULLIF, IIF - NULL handling & inline conditional
-- ============================================================

CREATE TABLE IF NOT EXISTS students (
    student_id  INT PRIMARY KEY,
    name        VARCHAR(100),
    test_score  INT,       -- NULL means not taken
    midterm_score INT,     -- NULL means not taken
    final_score   INT      -- NULL means not taken
);

INSERT INTO students VALUES
(1, 'Alice',   85, 90, 88),
(2, 'Bob',     70, NULL, 75),
(3, 'Charlie', NULL, NULL, NULL),
(4, 'Diana',   92, 88, NULL),
(5, 'Eve',     NULL, 78, 82);

-- COALESCE: return first non-NULL value
SELECT name,
       test_score,
       midterm_score,
       final_score,
       COALESCE(test_score, midterm_score, final_score, 0) AS best_available_score
FROM students;

-- COALESCE for default values
SELECT name,
       COALESCE(test_score, 0) AS test_score_filled,
       COALESCE(midterm_score, 0) AS midterm_filled
FROM students;

-- NULLIF: returns NULL if both args equal, else returns first arg
SELECT NULLIF(10, 10) AS equal_nulls,   -- returns NULL
       NULLIF(10, 5)  AS not_equal;     -- returns 10

-- Practical: avoid division by zero
SELECT name, test_score, midterm_score,
       test_score / NULLIF(midterm_score, 0) AS ratio
FROM students;

-- NULLIF with empty strings
SELECT name,
       NULLIF(TRIM(name), '') AS cleaned_name
FROM students;

-- IIF: inline IF-THEN-ELSE (SQL Server 2012+, also in MySQL 4.0+, SQLite)
-- SQL Server:  IIF(condition, true_val, false_val)
-- MySQL:       IF(condition, true_val, false_val)
-- SQLite:      IIF(condition, true_val, false_val)
-- PostgreSQL:  CASE WHEN ... END (no IIF)

-- SQLite/MySQL/ SQL Server:
SELECT name, test_score,
       IIF(test_score >= 70, 'Pass', 'Fail') AS test_result
FROM students;

-- Nested IIF
SELECT name, test_score,
       IIF(test_score IS NULL, 'Not Taken',
           IIF(test_score >= 90, 'A',
               IIF(test_score >= 80, 'B',
                   IIF(test_score >= 70, 'C', 'F')))) AS grade
FROM students;

-- Equivalent using CASE (cross-database)
SELECT name, test_score,
       CASE WHEN test_score IS NULL THEN 'Not Taken'
            WHEN test_score >= 90 THEN 'A'
            WHEN test_score >= 80 THEN 'B'
            WHEN test_score >= 70 THEN 'C'
            ELSE 'F'
       END AS grade
FROM students;

-- Cleanup
DROP TABLE IF EXISTS students;
