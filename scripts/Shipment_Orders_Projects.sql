-- ============================================
-- 📦 Data Exploration & Sales Analysis Queries
-- Dataset: orders_data
-- ============================================

-- 🔍 View all data
SELECT * FROM orders_data;


-- 🎯 1. List all distinct cities where orders have been shipped
SELECT DISTINCT City
FROM orders_data;


-- 💰 2. Calculate total selling price and profits for each order
SELECT
    [Order Id],
    SUM(Quantity * Unit_Selling_Price) AS Total_Selling_Price,
    SUM(Quantity * Unit_Profit) AS Total_Profit
FROM orders_data
GROUP BY [Order Id]
ORDER BY Total_Profit DESC;


-- 🚚 3. Find orders from 'Technology' category shipped via 'Second Class'
SELECT 
    [Order Id],
    [Order Date]
FROM orders_data
WHERE Category = 'Technology'
  AND [Ship Mode] = 'Second Class'
ORDER BY [Order Date];


-- 💳 4. Calculate the average order value (AOV)
SELECT 
    AVG(Quantity * Unit_Selling_Price) AS average_order_value,
    CAST(AVG(Quantity * Unit_Selling_Price) AS DECIMAL(10, 2)) AS AOV
FROM orders_data;


-- 🏙️ 5. Find the city with the highest quantity of products ordered
SELECT TOP 1
    City,
    SUM(Quantity) AS total_quantity
FROM orders_data
GROUP BY City
ORDER BY total_quantity DESC;


-- 🧮 6. Rank orders by quantity within each region
SELECT
    [Order Id],
    Region,
    SUM(Quantity) AS total_order,
    DENSE_RANK() OVER(PARTITION BY Region ORDER BY SUM(Quantity) DESC) AS ranking
FROM orders_data
GROUP BY [Order Id], Region
ORDER BY Region, ranking;


-- 📅 7. List orders placed in Q1 (Jan–Mar), including total cost
SELECT 
    [Order Id],
    SUM(Quantity * Unit_Selling_Price) AS Total_cost
FROM orders_data
WHERE MONTH([Order Date]) IN (1, 2, 3)
GROUP BY [Order Id], [Order Date]
ORDER BY Total_cost DESC;


-- 🔝 8. Top 10 products by total profit
SELECT TOP 10
    [Product Id],
    SUM([Total Profit by Order]) AS Total_Profit
FROM orders_data
GROUP BY [Product Id]
ORDER BY Total_Profit DESC;


-- 🥇 9. Alternate: Top 10 products using ROW_NUMBER
WITH cte AS (
    SELECT
        [Product Id],
        SUM([Total Profit by Order]) AS Total_Profit,
        ROW_NUMBER() OVER (ORDER BY SUM([Total Profit by Order]) DESC) AS ranking
    FROM orders_data
    GROUP BY [Product Id]
)
SELECT [Product Id], Total_Profit
FROM cte
WHERE ranking <= 10;


-- 🌍 10. Top 3 best-selling products in each region
WITH cte AS (
    SELECT
        Region,
        [Product Id],
        SUM(Quantity * Unit_Selling_Price) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SUM(Quantity * Unit_Selling_Price) DESC) AS ranking
    FROM orders_data
    GROUP BY Region, [Product Id]
)
SELECT *
FROM cte
WHERE ranking <= 3;


-- 📈 11. Month-over-month sales comparison for 2022 vs 2023
WITH monthly_sales AS (
    SELECT
        YEAR([Order Date]) AS Order_Year,
        MONTH([Order Date]) AS Order_month,
        SUM(Quantity * Unit_Selling_Price) AS Total_Sales
    FROM orders_data
    WHERE YEAR([Order Date]) IN (2022, 2023)
    GROUP BY YEAR([Order Date]), MONTH([Order Date])
)
SELECT 
    Order_month,
    ROUND(SUM(CASE WHEN Order_Year = 2022 THEN Total_Sales ELSE 0 END), 2) AS sales_2022,
    ROUND(SUM(CASE WHEN Order_Year = 2023 THEN Total_Sales ELSE 0 END), 2) AS sales_2023
FROM monthly_sales 
GROUP BY Order_month
ORDER BY Order_month;


-- 🗓️ 12. For each category, find the month with the highest sales
WITH cte AS (
    SELECT 
        Category, 
        FORMAT([Order Date], 'yyyy-MM') AS order_year_month,
        SUM(Quantity * Unit_Selling_Price) AS Total_Sales,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY SUM(Quantity * Unit_Selling_Price) DESC) AS rn
    FROM orders_data
    GROUP BY Category, FORMAT([Order Date], 'yyyy-MM')
)
SELECT
    Category AS output_Category,
    order_year_month AS output_order_year_month, 
    Total_Sales AS out_Total_Sales
FROM cte
WHERE rn = 1;


-- 🧾 Alternate method using month names
WITH category_monthly_sales AS (
    SELECT
        Category,
        MONTH([Order Date]) AS Order_Month,
        DATENAME(MONTH, [Order Date]) AS Month_Name,
        SUM(Quantity * Unit_Selling_Price) AS Total_Sales
    FROM orders_data
    GROUP BY Category, MONTH([Order Date]), DATENAME(MONTH, [Order Date])
),
ranked_sales AS (
    SELECT *,
        RANK() OVER(PARTITION BY Category ORDER BY Total_Sales DESC) AS sales_rank
    FROM category_monthly_sales
)
SELECT 
    Category,
    Order_Month,
    Month_Name,
    Total_Sales
FROM ranked_sales
WHERE sales_rank = 1
ORDER BY Category;


-- 🔼 13. Which sub-category had highest sales growth in 2023 compared to 2022?
WITH yearly_sales AS (
    SELECT
        [Sub Category] AS sub_category,
        YEAR([Order Date]) AS order_year,
        SUM(Quantity * Unit_Selling_Price) AS total_sales
    FROM orders_data
    GROUP BY [Sub Category], YEAR([Order Date])
),
sales_year AS (
    SELECT
        sub_category,
        ROUND(SUM(CASE WHEN order_year = 2022 THEN total_sales ELSE 0 END), 2) AS sales_2022,
        ROUND(SUM(CASE WHEN order_year = 2023 THEN total_sales ELSE 0 END), 2) AS sales_2023
    FROM yearly_sales
    GROUP BY sub_category
)
SELECT TOP 1 
    sub_category AS [Sub Category], 
    sales_2022 AS [Sales in 2022],
    sales_2023 AS [Sales in 2023],
    (sales_2023 - sales_2022) AS [Diff in Amount]
FROM sales_year
ORDER BY [Diff in Amount] DESC;
