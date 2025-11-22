-- QUESTION:
-- You are given a table containing product launches by company for the years 2019 and 2020.
-- Write a query to calculate the net difference between the number of products launched 
-- in 2020 compared to the previous year (2019) for each company.
-- Output the company name along with the net difference.

-- SOLUTION:

-- Step 1: Count how many products each company launched in 2019 and 2020
WITH product_counts AS (
    SELECT 
        company_name,
        SUM(CASE WHEN year = 2019 THEN 1 ELSE 0 END) AS products_2019,
        SUM(CASE WHEN year = 2020 THEN 1 ELSE 0 END) AS products_2020
    FROM car_launches
    WHERE year IN (2019, 2020)
    GROUP BY company_name
)

-- Step 2: Calculate the net difference (2020 minus 2019)
SELECT 
    company_name,
    (products_2020 - products_2019) AS net_difference
FROM product_counts
ORDER BY net_difference DESC;


         
         