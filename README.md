# FlexiMart Data Architecture Project

**Student Name:** Hazil Tellis
**Student ID:** 25071129  
**Course:** Data for Artificial Intelligence  
**Assignment:** AI Data Architecture Design and Implementation  
**Submission Mode:** GitHub Repository  

---

## 📌 Project Overview

This project implements an end-to-end data architecture solution for **FlexiMart**, an e-commerce platform.  
The solution covers data ingestion, cleansing, relational storage, NoSQL analysis, and data warehousing to enable scalable analytics and business intelligence.

The project demonstrates practical implementation of **ETL pipelines**, **database schema design**, **MongoDB NoSQL modeling**, and **OLAP analytics using a star schema**.

---

## 📂 Repository Structure

BA_25071129-fleximart-data-architecture
│
├── data/
│ ├── customers_raw.csv
│ ├── products_raw.csv
│ └── sales_raw.csv
│
├── part1-database-etl/
│ ├── etl_pipeline.py
│ ├── schema_documentation.md
│ ├── business_queries.sql
│ └── data_quality_report.txt
│
├── part2-nosql/
│ ├── nosql_analysis.md
│ ├── mongodb_operations.js
│ └── products_catalog.json
│
├── part3-data-warehouse/
│ ├── warehouse_schema.sql
│ ├── star_schema_design.md
│ ├── warehouse_data.sql
│ └── analytics_queries.sql
| └── README.md
│
└── README.md

yaml
Copy code

---

## 🛠 Technologies Used

- **Python 3.x** (ETL pipeline)
- **Pandas** (Data cleaning & transformation)
- **MySQL 8.0** (Relational database & data warehouse)
- **MongoDB** (NoSQL analysis)
- **SQL** (OLTP & OLAP queries)
- **Git & GitHub** (Version control & submission)

---

## ⚙️ Setup Instructions

### 1️⃣ Database Setup (MySQL)

```bash
CREATE DATABASE fleximart;
CREATE DATABASE fleximart_dw;
