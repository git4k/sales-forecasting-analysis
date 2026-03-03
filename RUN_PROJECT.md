# 🚀 How to Run This Project

## Step-by-Step Execution Guide

### 1. Setup Environment

```bash
# Install dependencies
pip install -r requirements.txt
```

### 2. Generate Dataset

```bash
# Generate 50,000+ sales records
python generate_dataset.py
```

**Output:** `data/raw/superstore.csv` (50,100 records)

### 3. Run Data Cleaning & EDA

```bash
# Open Jupyter notebook
jupyter notebook notebooks/01_data_cleaning_eda.ipynb

# Run all cells (Kernel → Restart & Run All)
```

**Outputs:**
- `data/processed/superstore_clean.csv` (cleaned data)
- 6 visualization charts in `outputs/`
- Business insights and statistics

### 4. Run ML Forecasting

```bash
# Open ML notebook
jupyter notebook notebooks/02_ml_forecasting.ipynb

# Run all cells
```

**Outputs:**
- Trained Linear Regression and Random Forest models
- Model comparison (R², MAE, RMSE)
- Forecast visualizations
- `outputs/forecast_results.csv`

### 5. SQL Analysis

```bash
# Load data to SQLite
python load_to_sql.py

# Run SQL queries
sqlite3 superstore.db < sql/sales_queries.sql
```

**Outputs:**
- `superstore.db` database
- 12 analytical query results

### 6. Power BI Dashboard

1. Open Power BI Desktop
2. Get Data → Text/CSV → Load `data/processed/superstore_clean.csv`
3. Create DAX measures (see `dashboard/DAX_measures.md`)
4. Build visualizations:
   - Sales trend line chart
   - Regional map
   - Category bar chart
   - KPI cards
5. Add slicers for Region, Category, Year
6. Publish to Power BI Service

---

## 📊 Expected Results

### Data Cleaning
- 50,000+ records processed
- Missing values handled
- Outliers removed
- Date features extracted

### EDA Insights
- Total revenue: $10M+
- Best category: Technology/Office Supplies
- Top region: West
- Optimal discount: 10-15%

### ML Models
- Linear Regression: ~85-90% accuracy
- Random Forest: ~90-95% accuracy
- MAE: $10k-15k
- RMSE: $15k-20k

### SQL Analysis
- 12 business intelligence queries
- YoY growth calculations
- Customer segmentation
- Profitability analysis

---

## 🎯 Quick Run (All Steps)

```bash
# 1. Generate data
python generate_dataset.py

# 2. Run notebooks (in Jupyter)
# - 01_data_cleaning_eda.ipynb
# - 02_ml_forecasting.ipynb

# 3. SQL analysis
python load_to_sql.py
sqlite3 superstore.db < sql/sales_queries.sql

# 4. Power BI (manual)
```

---

## 📁 Output Files

After running all steps, you'll have:

```
outputs/
├── sales_trend.png
├── category_performance.png
├── regional_performance.png
├── discount_impact.png
├── seasonal_patterns.png
├── correlation_heatmap.png
├── forecast_linear_regression.png
├── forecast_random_forest.png
├── feature_importance.png
└── forecast_results.csv

data/processed/
└── superstore_clean.csv

superstore.db
```

---

## ⏱️ Estimated Time

- Setup: 5 minutes
- Data generation: 1 minute
- EDA notebook: 5-10 minutes
- ML notebook: 10-15 minutes
- SQL analysis: 2 minutes
- Power BI dashboard: 30-60 minutes

**Total: ~1-2 hours**

---

## 🐛 Troubleshooting

### Issue: Module not found
```bash
pip install -r requirements.txt
```

### Issue: Jupyter not opening
```bash
pip install jupyter
jupyter notebook
```

### Issue: SQLite command not found
- Windows: Download from https://www.sqlite.org/download.html
- Or use Python: `python -c "import sqlite3; ..."`

---

## ✅ Verification Checklist

- [ ] Dataset generated (50,000+ records)
- [ ] EDA notebook completed
- [ ] 6 EDA charts saved
- [ ] ML notebook completed
- [ ] Forecast charts saved
- [ ] SQL database created
- [ ] SQL queries executed
- [ ] Power BI dashboard created

---

**Your professional data analytics project is complete!** 🎉
