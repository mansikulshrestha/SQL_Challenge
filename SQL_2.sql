
-- Amazon (Hard Level) SQL Interview Question — Solution

-- Question:
-- Given a table 'sf_transactions' of purchases by date, 
-- calculate the month-over-month (MoM) percentage change 
-- in revenue.
--
-- The output should include:
--   - year-month (YYYY-MM)
--   - total revenue
--   - percentage change from the previous month (rounded to 2 decimals)
--
-- Formula:
-- ((this_month_revenue - last_month_revenue) / last_month_revenue) * 100



------------------------------------------------------------
-- Step 0: Schema and Sample Dataset
------------------------------------------------------------
CREATE TABLE sf_transactions (
    id INT,
    created_at DATETIME,
    value INT,
    purchase_id INT
);

INSERT INTO sf_transactions VALUES
(1, '2019-01-01 00:00:00', 172692, 43),
(2, '2019-01-05 00:00:00', 177194, 36),
(3, '2019-01-09 00:00:00', 109513, 30),
(4, '2019-01-13 00:00:00', 164911, 30),
(5, '2019-01-17 00:00:00', 198872, 39),
(6, '2019-01-21 00:00:00', 184853, 31),
(7, '2019-01-25 00:00:00', 186817, 26),
(8, '2019-01-29 00:00:00', 137784, 22),
(9, '2019-02-02 00:00:00', 140032, 25),
(10, '2019-02-06 00:00:00', 116948, 43),
(11, '2019-02-10 00:00:00', 162515, 25),
(12, '2019-02-14 00:00:00', 114256, 12),
(13, '2019-02-18 00:00:00', 197465, 48),
(14, '2019-02-22 00:00:00', 120741, 20),
(15, '2019-02-26 00:00:00', 100074, 49),
(16, '2019-03-02 00:00:00', 157548, 19),
(17, '2019-03-06 00:00:00', 105506, 16),
(18, '2019-03-10 00:00:00', 189351, 46),
(19, '2019-03-14 00:00:00', 191231, 29),
(20, '2019-03-18 00:00:00', 120575, 44),
(21, '2019-03-22 00:00:00', 151688, 47),
(22, '2019-03-26 00:00:00', 102327, 18),
(23, '2019-03-30 00:00:00', 156147, 25);


-- Step 1: View the Data

SELECT * FROM sf_transactions;



-- Step 2: Calculate Total Revenue per Month

WITH MonthlyRevenue AS (
    SELECT 
        DATE_FORMAT(created_at, '%Y-%m') AS years_month,
        SUM(value) AS total_revenue
    FROM sf_transactions
    GROUP BY DATE_FORMAT(created_at, '%Y-%m')
),


-- Step 3: Retrieve Previous Month’s Revenue using LAG()

RevenueChange AS (
    SELECT 
        years_month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY years_month) AS lastmonth_revenue
    FROM MonthlyRevenue
)



-- Step 4: Compute Month-over-Month Percentage Change

SELECT 
    years_month,
    total_revenue,
    ROUND(
        CASE  
            WHEN lastmonth_revenue IS NULL THEN NULL
            ELSE ((total_revenue - lastmonth_revenue) / lastmonth_revenue) * 100
        END,
    2) AS percentage_change
FROM RevenueChange
ORDER BY years_month;



-- Explanation:
-- 1. The MonthlyRevenue CTE aggregates total revenue by month.
-- 2. The RevenueChange CTE uses LAG() to bring in the previous month’s revenue.
-- 3. The final SELECT calculates the month-over-month percentage change 
--    and rounds it to two decimal places.

