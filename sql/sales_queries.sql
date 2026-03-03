-- Sales Performance Analysis - SQL Queries
-- Database: SQLite
-- Purpose: Business Intelligence and Analytics

-- ============================================================================
-- 1. MONTHLY REVENUE AGGREGATION
-- ============================================================================
-- Track revenue trends over time
SELECT 
    strftime('%Y-%m', Order_Date) AS Month,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Sales), 2) AS Avg_Order_Value,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
FROM superstore
GROUP BY Month
ORDER BY Month;

-- ============================================================================
-- 2. TOP 10 PRODUCTS BY PROFIT
-- ============================================================================
-- Identify most profitable products
SELECT 
    Product_Name,
    Category,
    Sub_Category,
    COUNT(*) AS Order_Count,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Profit_Margin
FROM superstore
GROUP BY Product_Name, Category, Sub_Category
ORDER BY Total_Profit DESC
LIMIT 10;

-- ============================================================================
-- 3. REGION-WISE SALES COMPARISON
-- ============================================================================
-- Compare performance across regions
SELECT 
    Region,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Sales), 2) AS Avg_Order_Value,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
FROM superstore
GROUP BY Region
ORDER BY Total_Revenue DESC;

-- ============================================================================
-- 4. YEAR-OVER-YEAR GROWTH CALCULATION (Window Functions)
-- ============================================================================
-- Calculate YoY growth using window functions
WITH yearly_sales AS (
    SELECT 
        strftime('%Y', Order_Date) AS Year,
        ROUND(SUM(Sales), 2) AS Total_Revenue,
        ROUND(SUM(Profit), 2) AS Total_Profit
    FROM superstore
    GROUP BY Year
)
SELECT 
    Year,
    Total_Revenue,
    Total_Profit,
    LAG(Total_Revenue) OVER (ORDER BY Year) AS Prev_Year_Revenue,
    ROUND(
        (Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY Year)) / 
        LAG(Total_Revenue) OVER (ORDER BY Year) * 100, 
        2
    ) AS Revenue_Growth_Pct,
    ROUND(
        (Total_Profit - LAG(Total_Profit) OVER (ORDER BY Year)) / 
        LAG(Total_Profit) OVER (ORDER BY Year) * 100, 
        2
    ) AS Profit_Growth_Pct
FROM yearly_sales
ORDER BY Year;

-- ============================================================================
-- 5. DISCOUNT IMPACT ON PROFIT (Using CTEs)
-- ============================================================================
-- Analyze how discounts affect profitability
WITH discount_analysis AS (
    SELECT 
        CASE 
            WHEN Discount = 0 THEN 'No Discount'
            WHEN Discount <= 0.10 THEN '1-10%'
            WHEN Discount <= 0.20 THEN '11-20%'
            WHEN Discount <= 0.30 THEN '21-30%'
            ELSE 'Above 30%'
        END AS Discount_Range,
        Discount,
        Sales,
        Profit,
        Profit_Margin
    FROM superstore
)
SELECT 
    Discount_Range,
    COUNT(*) AS Order_Count,
    ROUND(AVG(Sales), 2) AS Avg_Sales,
    ROUND(AVG(Profit), 2) AS Avg_Profit,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Profit_Margin,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM discount_analysis
GROUP BY Discount_Range
ORDER BY 
    CASE Discount_Range
        WHEN 'No Discount' THEN 1
        WHEN '1-10%' THEN 2
        WHEN '11-20%' THEN 3
        WHEN '21-30%' THEN 4
        ELSE 5
    END;

-- ============================================================================
-- 6. CATEGORY PERFORMANCE BY REGION
-- ============================================================================
-- Cross-analysis of category and region
SELECT 
    Region,
    Category,
    COUNT(*) AS Order_Count,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Profit_Margin), 2) AS Avg_Profit_Margin
FROM superstore
GROUP BY Region, Category
ORDER BY Region, Total_Sales DESC;

-- ============================================================================
-- 7. CUSTOMER SEGMENTATION - HIGH VALUE CUSTOMERS
-- ============================================================================
-- Identify top customers by revenue
SELECT 
    Customer_ID,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Sales), 2) AS Avg_Order_Value,
    MAX(Order_Date) AS Last_Order_Date
FROM superstore
GROUP BY Customer_ID
HAVING Total_Revenue > 5000
ORDER BY Total_Revenue DESC
LIMIT 20;

-- ============================================================================
-- 8. QUARTERLY PERFORMANCE TRENDS
-- ============================================================================
-- Analyze seasonal patterns by quarter
SELECT 
    strftime('%Y', Order_Date) AS Year,
    Quarter,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Sales), 2) AS Avg_Order_Value
FROM superstore
GROUP BY Year, Quarter
ORDER BY Year, Quarter;

-- ============================================================================
-- 9. SHIPPING PERFORMANCE ANALYSIS
-- ============================================================================
-- Analyze shipping efficiency
SELECT 
    Region,
    ROUND(AVG(Shipping_Days), 2) AS Avg_Shipping_Days,
    MIN(Shipping_Days) AS Min_Shipping_Days,
    MAX(Shipping_Days) AS Max_Shipping_Days,
    COUNT(*) AS Total_Orders
FROM superstore
GROUP BY Region
ORDER BY Avg_Shipping_Days;

-- ============================================================================
-- 10. SUB-CATEGORY PROFITABILITY RANKING
-- ============================================================================
-- Rank sub-categories by profitability
SELECT 
    Category,
    Sub_Category,
    COUNT(*) AS Order_Count,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct,
    RANK() OVER (PARTITION BY Category ORDER BY SUM(Profit) DESC) AS Profit_Rank
FROM superstore
GROUP BY Category, Sub_Category
ORDER BY Category, Profit_Rank;

-- ============================================================================
-- 11. MONTHLY RUNNING TOTAL (Cumulative Revenue)
-- ============================================================================
-- Calculate running total of revenue
SELECT 
    strftime('%Y-%m', Order_Date) AS Month,
    ROUND(SUM(Sales), 2) AS Monthly_Revenue,
    ROUND(SUM(SUM(Sales)) OVER (ORDER BY strftime('%Y-%m', Order_Date)), 2) AS Cumulative_Revenue
FROM superstore
GROUP BY Month
ORDER BY Month;

-- ============================================================================
-- 12. PRODUCT PERFORMANCE WITH MOVING AVERAGE
-- ============================================================================
-- Calculate 3-month moving average for top products
WITH monthly_product_sales AS (
    SELECT 
        Product_Name,
        strftime('%Y-%m', Order_Date) AS Month,
        ROUND(SUM(Sales), 2) AS Monthly_Sales
    FROM superstore
    WHERE Product_Name IN (
        SELECT Product_Name
        FROM superstore
        GROUP BY Product_Name
        ORDER BY SUM(Sales) DESC
        LIMIT 5
    )
    GROUP BY Product_Name, Month
)
SELECT 
    Product_Name,
    Month,
    Monthly_Sales,
    ROUND(AVG(Monthly_Sales) OVER (
        PARTITION BY Product_Name 
        ORDER BY Month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS Moving_Avg_3M
FROM monthly_product_sales
ORDER BY Product_Name, Month;

-- ============================================================================
-- END OF QUERIES
-- ============================================================================
