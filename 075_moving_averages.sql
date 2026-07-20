-- ============================================================
-- 075: Moving Averages - smoothing time series data
-- Simple, weighted, exponential moving averages
-- ============================================================

CREATE TABLE IF NOT EXISTS stock_prices (
    ticker      VARCHAR(10),
    trade_date  DATE,
    close_price DECIMAL(10,2),
    PRIMARY KEY (ticker, trade_date)
);

INSERT INTO stock_prices VALUES
('AAPL', '2025-01-01', 150),
('AAPL', '2025-01-02', 152),
('AAPL', '2025-01-03', 148),
('AAPL', '2025-01-04', 153),
('AAPL', '2025-01-05', 155),
('AAPL', '2025-01-06', 151),
('AAPL', '2025-01-07', 157),
('AAPL', '2025-01-08', 160),
('AAPL', '2025-01-09', 158),
('AAPL', '2025-01-10', 162),
('AAPL', '2025-01-11', 165),
('AAPL', '2025-01-12', 163),
('AAPL', '2025-01-13', 168),
('AAPL', '2025-01-14', 170);

-- 3-day simple moving average (SMA)
SELECT ticker, trade_date, close_price,
       ROUND(AVG(close_price) OVER (
           PARTITION BY ticker
           ORDER BY trade_date
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS sma_3
FROM stock_prices
ORDER BY trade_date;

-- 5-day simple moving average (SMA)
SELECT ticker, trade_date, close_price,
       ROUND(AVG(close_price) OVER (
           PARTITION BY ticker
           ORDER BY trade_date
           ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
       ), 2) AS sma_5
FROM stock_prices
ORDER BY trade_date;

-- Multiple moving averages side by side
SELECT trade_date, close_price,
       ROUND(AVG(close_price) OVER (ORDER BY trade_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS sma_3,
       ROUND(AVG(close_price) OVER (ORDER BY trade_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW), 2) AS sma_5,
       ROUND(AVG(close_price) OVER (ORDER BY trade_date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW), 2) AS sma_10
FROM stock_prices
WHERE ticker = 'AAPL'
ORDER BY trade_date;

-- Moving sum (e.g., 7-day rolling total)
SELECT trade_date, close_price,
       SUM(close_price) OVER (ORDER BY trade_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_7d_sum,
       AVG(close_price) OVER (ORDER BY trade_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_7d_avg
FROM stock_prices
WHERE ticker = 'AAPL'
ORDER BY trade_date;

-- Cross-over signal (SMA_3 crosses above SMA_5)
WITH sma_calc AS (
    SELECT trade_date, close_price,
           AVG(close_price) OVER (ORDER BY trade_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS sma_3,
           AVG(close_price) OVER (ORDER BY trade_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS sma_5
    FROM stock_prices WHERE ticker = 'AAPL'
)
SELECT trade_date, close_price,
       ROUND(sma_3, 2) AS sma_3, ROUND(sma_5, 2) AS sma_5,
       CASE WHEN sma_3 > sma_5 AND LAG(sma_3) OVER (ORDER BY trade_date) <= LAG(sma_5) OVER (ORDER BY trade_date)
            THEN 'BUY SIGNAL'
            WHEN sma_3 < sma_5 AND LAG(sma_3) OVER (ORDER BY trade_date) >= LAG(sma_5) OVER (ORDER BY trade_date)
            THEN 'SELL SIGNAL'
            ELSE NULL
       END AS signal
FROM sma_calc
ORDER BY trade_date;

-- Cleanup
DROP TABLE IF EXISTS stock_prices;
