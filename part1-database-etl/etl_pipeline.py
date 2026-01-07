# ============================================
# FlexiMart ETL Pipeline
# Part 1 - Complete ETL (Extract, Transform, Load)
# ============================================

import pandas as pd
import mysql.connector
from dateutil import parser
import re
import os

# -----------------------------
# DATABASE CONNECTION
# -----------------------------
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="CIInvest@22",  # <-- your MySQL password
    database="fleximart"
)

cursor = conn.cursor()
print("Connected to database")

# -----------------------------
# HELPER FUNCTIONS
# -----------------------------
def standardize_phone(phone):
    if pd.isna(phone):
        return None
    phone = re.sub(r"\D", "", str(phone))
    if phone.startswith("0"):
        phone = phone[1:]
    if len(phone) > 10:
        phone = phone[-10:]
    return "+91-" + phone

def parse_date_safe(date_val):
    try:
        return parser.parse(str(date_val)).date()
    except:
        return None

print("Helper functions loaded")

# -----------------------------
# FILE PATH SETUP
# -----------------------------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(BASE_DIR, "..", "data")

customers = pd.read_csv(os.path.join(DATA_DIR, "customers_raw.csv"))
products = pd.read_csv(os.path.join(DATA_DIR, "products_raw.csv"))
sales = pd.read_csv(os.path.join(DATA_DIR, "sales_raw.csv"))

print("CSV files loaded")

# -----------------------------
# TRANSFORM CUSTOMERS
# -----------------------------
customers.drop_duplicates(subset=["customer_id"], inplace=True)
customers.dropna(subset=["email"], inplace=True)
customers["phone"] = customers["phone"].apply(standardize_phone)
customers["registration_date"] = customers["registration_date"].apply(parse_date_safe)
customers["city"] = customers["city"].str.title()

print("Customers cleaned")

# -----------------------------
# TRANSFORM PRODUCTS
# -----------------------------
products.dropna(subset=["price"], inplace=True)
products["stock_quantity"] = products["stock_quantity"].fillna(0)
products["category"] = products["category"].str.title()
products["product_name"] = products["product_name"].str.strip()

print("Products cleaned")

# -----------------------------
# TRANSFORM SALES
# -----------------------------
sales.drop_duplicates(subset=["transaction_id"], inplace=True)
sales.dropna(subset=["customer_id", "product_id"], inplace=True)
sales["transaction_date"] = sales["transaction_date"].apply(parse_date_safe)

print("Sales cleaned")
print("ETL Step 1 (Extract + Transform) completed successfully")

# =========================================================
# LOAD PHASE
# =========================================================

# -----------------------------
# LOAD CUSTOMERS
# -----------------------------
insert_customer_sql = """
INSERT IGNORE INTO customers (first_name, last_name, email, phone, city, registration_date)
VALUES (%s, %s, %s, %s, %s, %s)
"""

customer_rows = customers[
    ["first_name", "last_name", "email", "phone", "city", "registration_date"]
].values.tolist()

cursor.executemany(insert_customer_sql, customer_rows)
conn.commit()
print(f"Inserted {cursor.rowcount} customers")

# -----------------------------
# LOAD PRODUCTS
# -----------------------------
insert_product_sql = """
INSERT IGNORE INTO products (product_name, category, price, stock_quantity)
VALUES (%s, %s, %s, %s)
"""

product_rows = products[
    ["product_name", "category", "price", "stock_quantity"]
].values.tolist()

cursor.executemany(insert_product_sql, product_rows)
conn.commit()
print(f"Inserted {cursor.rowcount} products")

# -----------------------------
# BUILD LOOKUPS
# -----------------------------
cursor.execute("SELECT customer_id, email FROM customers")
customer_lookup = {email: cid for cid, email in cursor.fetchall()}

cursor.execute("SELECT product_id, product_name FROM products")
product_lookup = {name: pid for pid, name in cursor.fetchall()}

# -----------------------------
# INSERT ORDERS
# -----------------------------
insert_order_sql = """
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES (%s, %s, %s, %s)
"""

order_map = {}

for _, row in sales.iterrows():
    customer_email = customers.loc[
        customers["customer_id"] == row["customer_id"], "email"
    ].values

    if len(customer_email) == 0:
        continue

    customer_id = customer_lookup.get(customer_email[0])
    if not customer_id:
        continue

    total_amount = row["quantity"] * row["unit_price"]

    cursor.execute(
        insert_order_sql,
        (customer_id, row["transaction_date"], total_amount, row["status"])
    )
    conn.commit()

    order_map[row["transaction_id"]] = cursor.lastrowid

print("Orders inserted")

# -----------------------------
# INSERT ORDER ITEMS
# -----------------------------
insert_item_sql = """
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
VALUES (%s, %s, %s, %s, %s)
"""

for _, row in sales.iterrows():
    if row["transaction_id"] not in order_map:
        continue

    product_name = products.loc[
        products["product_id"] == row["product_id"], "product_name"
    ].values

    if len(product_name) == 0:
        continue

    product_id = product_lookup.get(product_name[0])
    if not product_id:
        continue

    subtotal = row["quantity"] * row["unit_price"]

    cursor.execute(
        insert_item_sql,
        (
            order_map[row["transaction_id"]],
            product_id,
            row["quantity"],
            row["unit_price"],
            subtotal
        )
    )

conn.commit()
print("Order items inserted")

# -----------------------------
# DATA QUALITY REPORT
# -----------------------------
report_lines = []
report_lines.append("FlexiMart Data Quality Report")
report_lines.append("=" * 35)

report_lines.append("\nCUSTOMERS DATA")
report_lines.append(f"Raw records: {len(pd.read_csv(os.path.join(DATA_DIR, 'customers_raw.csv')))}")
report_lines.append(f"After cleaning: {len(customers)}")

report_lines.append("\nPRODUCTS DATA")
report_lines.append(f"Raw records: {len(pd.read_csv(os.path.join(DATA_DIR, 'products_raw.csv')))}")
report_lines.append(f"After cleaning: {len(products)}")

report_lines.append("\nSALES DATA")
report_lines.append(f"Raw records: {len(pd.read_csv(os.path.join(DATA_DIR, 'sales_raw.csv')))}")
report_lines.append(f"After cleaning: {len(sales)}")

report_path = os.path.join(BASE_DIR, "data_quality_report.txt")
with open(report_path, "w") as f:
    for line in report_lines:
        f.write(line + "\n")

print("Data quality report generated")

# -----------------------------
# CLOSE CONNECTION
# -----------------------------
cursor.close()
conn.close()

print("ETL Load completed successfully")
