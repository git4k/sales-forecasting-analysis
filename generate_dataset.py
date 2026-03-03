import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Set random seed for reproducibility
np.random.seed(42)

# Generate 50,000 records
n_records = 50000

# Date range: 4 years
start_date = datetime(2020, 1, 1)
end_date = datetime(2023, 12, 31)
date_range = (end_date - start_date).days

# Generate data
data = {
    'Order_ID': [f'ORD-{i:06d}' for i in range(1, n_records + 1)],
    'Order_Date': [start_date + timedelta(days=np.random.randint(0, date_range)) for _ in range(n_records)],
    'Ship_Date': [],
    'Region': np.random.choice(['East', 'West', 'Central', 'South'], n_records, p=[0.3, 0.35, 0.2, 0.15]),
    'Category': np.random.choice(['Technology', 'Furniture', 'Office Supplies'], n_records, p=[0.3, 0.25, 0.45]),
    'Sub_Category': [],
    'Product_Name': [],
    'Sales': np.random.gamma(2, 100, n_records),  # Realistic sales distribution
    'Quantity': np.random.randint(1, 15, n_records),
    'Discount': np.random.choice([0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30], n_records, p=[0.3, 0.2, 0.2, 0.15, 0.10, 0.03, 0.02]),
    'Customer_ID': [f'CUS-{np.random.randint(1000, 5000):04d}' for _ in range(n_records)]
}

# Add ship dates (1-7 days after order)
data['Ship_Date'] = [order_date + timedelta(days=np.random.randint(1, 8)) for order_date in data['Order_Date']]

# Sub-categories based on category
sub_categories = {
    'Technology': ['Phones', 'Computers', 'Accessories', 'Copiers'],
    'Furniture': ['Chairs', 'Tables', 'Bookcases', 'Furnishings'],
    'Office Supplies': ['Paper', 'Binders', 'Pens', 'Storage', 'Art', 'Labels']
}

data['Sub_Category'] = [np.random.choice(sub_categories[cat]) for cat in data['Category']]

# Product names
products = {
    'Phones': ['iPhone 13', 'Samsung Galaxy', 'Google Pixel', 'OnePlus'],
    'Computers': ['Dell Laptop', 'HP Desktop', 'MacBook Pro', 'Lenovo ThinkPad'],
    'Accessories': ['Wireless Mouse', 'Keyboard', 'Webcam', 'USB Hub'],
    'Copiers': ['Canon Copier', 'HP Printer', 'Epson Scanner'],
    'Chairs': ['Executive Chair', 'Mesh Chair', 'Ergonomic Chair'],
    'Tables': ['Conference Table', 'Standing Desk', 'Office Desk'],
    'Bookcases': ['Wood Bookcase', 'Metal Shelf', 'Corner Bookcase'],
    'Furnishings': ['Office Lamp', 'Wall Clock', 'Desk Organizer'],
    'Paper': ['Copy Paper', 'Cardstock', 'Envelopes'],
    'Binders': ['3-Ring Binder', 'Report Cover', 'Sheet Protectors'],
    'Pens': ['Ballpoint Pen', 'Gel Pen', 'Marker Set'],
    'Storage': ['File Cabinet', 'Storage Box', 'Drawer Organizer'],
    'Art': ['Scissors', 'Tape', 'Glue'],
    'Labels': ['Address Labels', 'File Labels', 'Name Tags']
}

data['Product_Name'] = [np.random.choice(products[sub]) for sub in data['Sub_Category']]

# Calculate profit (realistic profit margins)
profit_margins = {
    'Technology': 0.15,
    'Furniture': 0.25,
    'Office Supplies': 0.35
}

df = pd.DataFrame(data)
df['Profit'] = df.apply(lambda row: row['Sales'] * (1 - row['Discount']) * profit_margins[row['Category']] + np.random.normal(0, 10), axis=1)

# Add some missing values (realistic scenario)
missing_indices = np.random.choice(df.index, size=int(n_records * 0.02), replace=False)
df.loc[missing_indices[:len(missing_indices)//2], 'Discount'] = np.nan
df.loc[missing_indices[len(missing_indices)//2:], 'Profit'] = np.nan

# Add some duplicates
duplicate_rows = df.sample(n=100)
df = pd.concat([df, duplicate_rows], ignore_index=True)

# Save to CSV
df.to_csv('data/raw/superstore.csv', index=False)

print(f"✓ Generated {len(df)} records")
print(f"✓ Date range: {df['Order_Date'].min()} to {df['Order_Date'].max()}")
print(f"✓ Total Sales: ${df['Sales'].sum():,.2f}")
print(f"✓ Total Profit: ${df['Profit'].sum():,.2f}")
print(f"✓ Missing values: {df.isnull().sum().sum()}")
print(f"✓ Duplicates: {df.duplicated().sum()}")
print("\nDataset saved to: data/raw/superstore.csv")
