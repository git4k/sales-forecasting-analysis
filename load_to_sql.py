import pandas as pd
import sqlite3

print("=" * 60)
print("LOADING DATA TO SQL DATABASE")
print("=" * 60)

# Load cleaned data
df = pd.read_csv('data/processed/superstore_clean.csv')
print(f"\n✓ Loaded {len(df)} records from CSV")

# Create SQLite database
conn = sqlite3.connect('superstore.db')

# Load data to SQL
df.to_sql('superstore', conn, if_exists='replace', index=False)
print(f"✓ Created table 'superstore' in superstore.db")

# Verify
cursor = conn.cursor()
cursor.execute("SELECT COUNT(*) FROM superstore")
count = cursor.fetchone()[0]
print(f"✓ Verified: {count} records in database")

# Show sample
print("\nSample query - Top 5 records:")
sample = pd.read_sql_query("SELECT * FROM superstore LIMIT 5", conn)
print(sample)

conn.close()
print("\n✓ Database ready for SQL analysis!")
print("=" * 60)
