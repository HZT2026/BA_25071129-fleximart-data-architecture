-- ============================================================
-- Task 3.3: OLAP Analytics Queries
-- Database: fleximart_dw
-- Schema: Star Schema (fact_sales, dim_date, dim_product, dim_customer)
-- ============================================================


/*
============================================================
Query 1: Monthly Sales Drill-Down Analysis (5 marks)
Business Scenario:
The CEO wants to analyze sales performance broken down by
Year → Quarter → Month for the year 2024.
============================================================
*/

SELECT
    d.year,
    d.quarter,
    d.month_name,
    SUM(f.total_amount) AS total_sales,
    SUM(f.quantity_sold) AS total_quantity
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
WHERE d.year = 2024
GROUP BY d.year, d.quarter, d.month, d.month_name
ORDER BY d.year, d.quarter, d.month;


-- ============================================================

/*
============================================================
Query 2: Product Performance Analysis (5 marks)
Business Scenario:
The product manager wants to identify the top 10 products
by revenue along with their category, total units sold,
and revenue contribution percentage.
============================================================
*/

SELECT
    p.product_name,
    p.category,
    SUM(f.quantity_sold) AS units_sold,
    SUM(f.total_amount) AS revenue,
    ROUND(
        SUM(f.total_amount) * 100.0 /
        SUM(SUM(f.total_amount)) OVER (),
        2
    ) AS revenue_percentage
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY p.product_key, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;


-- ============================================================

/*
============================================================
Query 3: Customer Segmentation Analysis (5 marks)
Business Scenario:
Marketing wants to segment customers into:
- High Value   : > ₹50,000
- Medium Value : ₹20,000 – ₹50,000
- Low Value    : < ₹20,000

Show customer count, total revenue, and average revenue
per customer in each segment.
============================================================
*/

WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.total_amount) AS total_spent
    FROM fact_sales f
    JOIN dim_customer c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)

SELECT
    CASE
        WHEN total_spent > 50000 THEN 'High Value'
        WHEN total_spent BETWEEN 20000 AND 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    SUM(total_spent) AS total_revenue,
    ROUND(AVG(total_spent), 2) AS avg_revenue_per_customer
FROM customer_spending
GROUP BY customer_segment
ORDER BY total_revenue DESC;
