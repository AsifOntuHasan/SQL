-- ============================================================
-- 089: Advanced Window Functions - Ranking & Distribution
-- ============================================================

CREATE TABLE IF NOT EXISTS sales (
    sale_id     INT PRIMARY KEY,
    salesperson VARCHAR(50),
    amount      DECIMAL(10,2),
    region      VARCHAR(20),
    sale_date   DATE
);

INSERT INTO sales VALUES
(1,  'Alice',   1200, 'North', '2025-01-15'),
(2,  'Bob',      800, 'South', '2025-01-16'),
(3,  'Alice',   1500, 'North', '2025-02-01'),
(4,  'Charlie',  900, 'East',  '2025-02-10'),
(5,  'Bob',     1100, 'South', '2025-02-15'),
(6,  'Alice',    700, 'North', '2025-03-01'),
(7,  'Charlie', 1300, 'East',  '2025-03-05'),
(8,  'Diana',   1600, 'West',  '2025-03-10'),
(9,  'Bob',      950, 'South', '2025-03-15'),
(10, 'Diana',   1400, 'West',  '2025-04-01');

-- PERCENT_RANK: relative rank (0 to 1)
SELECT salesperson, amount,
       RANK() OVER (ORDER BY amount DESC) AS rank,
       PERCENT_RANK() OVER (ORDER BY amount DESC) AS pct_rank,
       ROUND(PERCENT_RANK() OVER (ORDER BY amount DESC) * 100, 1) AS pct_rank_pct
FROM sales
ORDER BY amount DESC;

-- CUME_DIST (cumulative distribution): <= current value proportion
SELECT amount,
       CUME_DIST() OVER (ORDER BY amount) AS cume_dist,
       ROUND(CUME_DIST() OVER (ORDER BY amount) * 100, 1) AS percentile
FROM sales
ORDER BY amount;

-- NTILE with multiple buckets
SELECT salesperson, amount,
       NTILE(4) OVER (ORDER BY amount DESC) AS quartile,
       NTILE(10) OVER (ORDER BY amount DESC) AS decile,
       CASE NTILE(4) OVER (ORDER BY amount DESC)
           WHEN 1 THEN 'Top 25%'
           WHEN 2 THEN '25-50%'
           WHEN 3 THEN '50-75%'
           WHEN 4 THEN 'Bottom 25%'
       END AS quartile_label
FROM sales;

-- Ranking within partitions
SELECT region, salesperson, amount,
       ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS region_rank,
       RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS region_rank_with_ties,
       DENSE_RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS region_dense_rank
FROM sales
ORDER BY region, amount DESC;

-- Top N per partition
WITH ranked AS (
    SELECT region, salesperson, amount,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS rn
    FROM sales
)
SELECT region, salesperson, amount
FROM ranked
WHERE rn <= 2
ORDER BY region, rn;

-- Cleanup
DROP TABLE IF EXISTS sales;
