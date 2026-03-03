# Power BI DAX Measures for Sales Dashboard

## Core KPI Measures

### 1. Total Revenue
```dax
Total Revenue = SUM(superstore[Sales])
```

### 2. Total Profit
```dax
Total Profit = SUM(superstore[Profit])
```

### 3. Total Orders
```dax
Total Orders = COUNTROWS(superstore)
```

### 4. Average Order Value
```dax
Avg Order Value = DIVIDE([Total Revenue], [Total Orders], 0)
```

### 5. Profit Margin %
```dax
Profit Margin % = 
DIVIDE([Total Profit], [Total Revenue], 0) * 100
```

## Time Intelligence Measures

### 6. Month-over-Month Growth %
```dax
MoM Growth % = 
VAR CurrentMonthRevenue = [Total Revenue]
VAR PreviousMonthRevenue = 
    CALCULATE(
        [Total Revenue],
        DATEADD(superstore[Order_Date], -1, MONTH)
    )
RETURN
    DIVIDE(
        CurrentMonthRevenue - PreviousMonthRevenue,
        PreviousMonthRevenue,
        0
    ) * 100
```

### 7. Year-over-Year Growth %
```dax
YoY Growth % = 
VAR CurrentYearRevenue = [Total Revenue]
VAR PreviousYearRevenue = 
    CALCULATE(
        [Total Revenue],
        DATEADD(superstore[Order_Date], -1, YEAR)
    )
RETURN
    DIVIDE(
        CurrentYearRevenue - PreviousYearRevenue,
        PreviousYearRevenue,
        0
    ) * 100
```

### 8. Running Total Sales
```dax
Running Total Sales = 
CALCULATE(
    [Total Revenue],
    FILTER(
        ALLSELECTED(superstore[Order_Date]),
        superstore[Order_Date] <= MAX(superstore[Order_Date])
    )
)
```

### 9. Year-to-Date Revenue
```dax
YTD Revenue = 
TOTALYTD([Total Revenue], superstore[Order_Date])
```

### 10. Previous Year Revenue
```dax
Previous Year Revenue = 
CALCULATE(
    [Total Revenue],
    SAMEPERIODLASTYEAR(superstore[Order_Date])
)
```

## Advanced Analytical Measures

### 11. Average Discount %
```dax
Avg Discount % = 
AVERAGE(superstore[Discount]) * 100
```

### 12. Discount Impact on Profit
```dax
Discount Impact = 
VAR TotalDiscount = SUMX(superstore, superstore[Sales] * superstore[Discount])
RETURN
    TotalDiscount
```

### 13. Top 10% Customers Revenue
```dax
Top 10% Customers Revenue = 
VAR TotalCustomers = DISTINCTCOUNT(superstore[Customer_ID])
VAR Top10Pct = CEILING(TotalCustomers * 0.1, 1)
VAR TopCustomers = 
    TOPN(
        Top10Pct,
        SUMMARIZE(
            superstore,
            superstore[Customer_ID],
            "CustomerRevenue", [Total Revenue]
        ),
        [CustomerRevenue],
        DESC
    )
RETURN
    SUMX(TopCustomers, [CustomerRevenue])
```

### 14. Revenue per Customer
```dax
Revenue per Customer = 
DIVIDE(
    [Total Revenue],
    DISTINCTCOUNT(superstore[Customer_ID]),
    0
)
```

### 15. Profit per Order
```dax
Profit per Order = 
DIVIDE([Total Profit], [Total Orders], 0)
```

## Conditional Formatting Measures

### 16. Profit Status
```dax
Profit Status = 
IF(
    [Total Profit] > 0,
    "Profitable",
    "Loss"
)
```

### 17. Performance vs Target
```dax
Performance vs Target = 
VAR Target = 250000  // Set your target
VAR Actual = [Total Revenue]
RETURN
    IF(
        Actual >= Target,
        "Above Target",
        "Below Target"
    )
```

### 18. Growth Indicator
```dax
Growth Indicator = 
IF(
    [MoM Growth %] > 0,
    "▲ Growing",
    IF(
        [MoM Growth %] < 0,
        "▼ Declining",
        "→ Stable"
    )
)
```

## Ranking Measures

### 19. Category Rank by Revenue
```dax
Category Rank = 
RANKX(
    ALL(superstore[Category]),
    [Total Revenue],
    ,
    DESC,
    DENSE
)
```

### 20. Region Rank by Profit
```dax
Region Rank = 
RANKX(
    ALL(superstore[Region]),
    [Total Profit],
    ,
    DESC,
    DENSE
)
```

---

## Dashboard Visuals to Create

### 1. KPI Cards
- Total Revenue
- Total Profit
- Profit Margin %
- MoM Growth %

### 2. Sales Trend Line Chart
- X-axis: Order_Date (Month)
- Y-axis: Total Revenue
- Add Running Total Sales as secondary line

### 3. Regional Map
- Location: Region
- Size: Total Revenue
- Color: Profit Margin %

### 4. Category Bar Chart
- Axis: Category
- Values: Total Revenue, Total Profit
- Sort by Total Revenue descending

### 5. Discount Impact Scatter Plot
- X-axis: Discount
- Y-axis: Profit Margin %
- Size: Total Revenue

### 6. Top 10 Products Table
- Columns: Product_Name, Total Revenue, Total Profit, Profit Margin %
- Filter: Top 10 by Total Profit

### 7. Quarterly Performance Matrix
- Rows: Year
- Columns: Quarter
- Values: Total Revenue

### 8. Customer Segmentation Donut Chart
- Legend: Customer segments (High/Medium/Low value)
- Values: Count of customers

---

## Slicers to Add

1. **Date Slicer**
   - Field: Order_Date
   - Type: Between

2. **Region Slicer**
   - Field: Region
   - Type: Dropdown or List

3. **Category Slicer**
   - Field: Category
   - Type: Dropdown

4. **Year Slicer**
   - Field: Year
   - Type: List

---

## Bookmarks to Create

1. **Overview** - All visuals visible
2. **Regional Analysis** - Focus on regional performance
3. **Product Performance** - Focus on category and product analysis
4. **Time Trends** - Focus on temporal patterns

---

## Drill-Through Pages

### Product Details Page
- Drill-through field: Product_Name
- Visuals:
  - Product sales trend
  - Regional breakdown
  - Customer list
  - Profit margin analysis

### Customer Details Page
- Drill-through field: Customer_ID
- Visuals:
  - Customer purchase history
  - Product preferences
  - Revenue contribution
  - Last purchase date

---

## Row Level Security (RLS)

### Regional Manager Role
```dax
[Region] = USERNAME()
```

### Category Manager Role
```dax
[Category] = LOOKUPVALUE(
    Users[Category],
    Users[Email],
    USERPRINCIPALNAME()
)
```

---

## Tips for Implementation

1. Create a Date table for better time intelligence
2. Use calculated columns sparingly (prefer measures)
3. Format measures appropriately (currency, percentage)
4. Add tooltips for better user experience
5. Use consistent color scheme across visuals
6. Test RLS before publishing
7. Schedule refresh in Power BI Service
8. Create mobile layout for on-the-go access

---

**Your Power BI dashboard is now ready for professional presentation!** 📊
