# Star Schema Design – FlexiMart Data Warehouse

## 1. Overview

The FlexiMart data warehouse is designed using a **star schema** to support analytical
and reporting workloads. The star schema separates **measurable transactional data**
from **descriptive contextual data**, enabling fast query performance and simplified
SQL for business intelligence use cases.

The source MySQL database is optimized for OLTP operations, whereas this data warehouse
is optimized for **OLAP** workloads such as trend analysis, customer behavior analysis,
and product performance reporting.

---

## 2. Star Schema Structure

The schema consists of one **fact table** surrounded by multiple **dimension tables**.

### Fact Table
- `fact_sales`

### Dimension Tables
- `dim_customer`
- `dim_product`
- `dim_date`

This design allows analytical queries to aggregate sales metrics across multiple
dimensions such as time, product category, and customer location.

---

## 3. Fact Table Description

### fact_sales

**Purpose:**  
Stores quantitative sales metrics at the lowest level of granularity (per product,
per customer, per date).

**Attributes:**
- `sales_key` (Primary Key): Surrogate key for the fact table
- `customer_key` (Foreign Key): References dim_customer
- `product_key` (Foreign Key): References dim_product
- `date_key` (Foreign Key): References dim_date
- `quantity`: Number of units sold
- `total_sales`: Total sales amount for the transaction

**Granularity:**  
Each record represents the sale of a specific product to a specific customer on a
specific date.

---

## 4. Dimension Tables Description

### dim_customer

**Purpose:**  
Stores descriptive customer attributes used for customer-level analysis.

**Attributes:**
- `customer_key` (Primary Key): Surrogate key
- `customer_id`: Business key from source system
- `first_name`: Customer first name
- `last_name`: Customer last name
- `email`: Customer email address
- `city`: Customer city

**Usage Examples:**
- Identify top customers by revenue
- Analyze sales by customer location

---

### dim_product

**Purpose:**  
Stores descriptive product attributes used for product-level analysis.

**Attributes:**
- `product_key` (Primary Key): Surrogate key
- `product_id`: Business key from source system
- `product_name`: Product name
- `category`: Product category
- `price`: Product unit price

**Usage Examples:**
- Analyze revenue by product category
- Identify best-selling products

---

### dim_date

**Purpose:**  
Stores date-related attributes to support time-based analysis.

**Attributes:**
- `date_key` (Primary Key): Integer representation of date
- `full_date`: Actual calendar date
- `day`: Day of month
- `month`: Month number
- `year`: Year
- `quarter`: Quarter of the year

**Usage Examples:**
- Monthly and yearly sales trends
- Seasonal performance analysis

---

## 5. Data Flow from Source to Warehouse

1. Transactional data is extracted from the MySQL OLTP database using the ETL pipeline.
2. Dimension tables are populated first to generate surrogate keys.
3. Fact table records are loaded by mapping business keys to surrogate keys.
4. Aggregated and analytical queries are executed on the star schema for reporting.

This approach ensures historical consistency and improves query performance.

---

## 6. OLTP vs OLAP Comparison

| Aspect | OLTP (MySQL) | OLAP (Data Warehouse) |
|------|--------------|----------------------|
| Purpose | Transaction processing | Analytical reporting |
| Schema | Highly normalized | Star schema |
| Query Type | Inserts, updates | Aggregations, trends |
| Performance Focus | Write efficiency | Read efficiency |

The star schema simplifies complex analytical queries and enables efficient business
intelligence reporting for FlexiMart.
