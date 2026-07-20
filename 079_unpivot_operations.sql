-- ============================================================
-- 079: UNPIVOT - converting columns to rows
-- Note: Native UNPIVOT (SQL Server); CROSS JOIN method (others)
-- ============================================================

CREATE TABLE IF NOT EXISTS quarterly_sales (
    product     VARCHAR(50) PRIMARY KEY,
    q1          DECIMAL(10,2),
    q2          DECIMAL(10,2),
    q3          DECIMAL(10,2),
    q4          DECIMAL(10,2)
);

INSERT INTO quarterly_sales VALUES
('Laptop',   12000, 15000, 13500, 18000),
('Mouse',     5000,  5500,  4800,  6000),
('Keyboard',  3000,  3500,  3200,  4000);

-- UNPIVOT using CROSS JOIN (cross-database)
SELECT product, quarter, amount
FROM quarterly_sales
CROSS JOIN (
    SELECT 'Q1' AS quarter, q1 AS amount FROM quarterly_sales
    UNION ALL SELECT 'Q2', q2 FROM quarterly_sales
    UNION ALL SELECT 'Q3', q3 FROM quarterly_sales
    UNION ALL SELECT 'Q4', q4 FROM quarterly_sales
) AS unpivoted
WHERE quarterly_sales.product = unpivoted.product
ORDER BY product, quarter;

-- UNPIVOT using UNION ALL (simpler approach)
SELECT product, 'Q1' AS quarter, q1 AS amount FROM quarterly_sales
UNION ALL
SELECT product, 'Q2', q2 FROM quarterly_sales
UNION ALL
SELECT product, 'Q3', q3 FROM quarterly_sales
UNION ALL
SELECT product, 'Q4', q4 FROM quarterly_sales
ORDER BY product, quarter;

-- SQL Server native UNPIVOT:
/*
SELECT product, quarter, amount
FROM quarterly_sales
UNPIVOT (
    amount FOR quarter IN (q1, q2, q3, q4)
) AS unpvt;
*/

-- PostgreSQL: LATERAL join approach
/*
SELECT qs.product, v.quarter, v.amount
FROM quarterly_sales qs,
LATERAL (VALUES ('Q1', qs.q1), ('Q2', qs.q2), ('Q3', qs.q3), ('Q4', qs.q4)) AS v(quarter, amount);
*/

-- Verify: compare unpivoted total with original
WITH unpivoted AS (
    SELECT product, 'Q1' AS quarter, q1 AS amount FROM quarterly_sales
    UNION ALL SELECT product, 'Q2', q2 FROM quarterly_sales
    UNION ALL SELECT product, 'Q3', q3 FROM quarterly_sales
    UNION ALL SELECT product, 'Q4', q4 FROM quarterly_sales
)
SELECT product, SUM(amount) AS total_revenue,
       COUNT(*) AS quarter_count,
       AVG(amount) AS avg_quarterly
FROM unpivoted
GROUP BY product
ORDER BY product;

-- Cleanup
DROP TABLE IF EXISTS quarterly_sales;
