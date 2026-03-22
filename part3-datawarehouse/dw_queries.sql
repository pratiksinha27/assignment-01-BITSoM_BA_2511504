-- ============================================================
-- Part 3 — Analytical Queries
-- Run star_schema.sql first
-- ============================================================

-- Q1: Total sales revenue by product category for each month
SELECT
    d.year,
    d.month,
    d.month_name,
    p.category,
    ROUND(SUM(f.sales_amount), 2) AS total_revenue
FROM fact_sales f
JOIN dim_date    d ON f.date_id    = d.date_id
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY d.year, d.month, d.month_name, p.category
ORDER BY d.year, d.month, p.category;

-- Q2: Top 2 performing stores by total revenue
SELECT
    s.store_name,
    s.city,
    s.region,
    COUNT(f.sale_id)              AS total_transactions,
    ROUND(SUM(f.sales_amount), 2) AS total_revenue
FROM fact_sales f
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY s.store_id, s.store_name, s.city, s.region
ORDER BY total_revenue DESC
LIMIT 2;

-- Q3: Month-over-month sales trend across all stores
SELECT
    t.year,
    t.month,
    ROUND(t.monthly_sales, 2) AS monthly_revenue,
    ROUND(LAG(t.monthly_sales) OVER (ORDER BY t.year, t.month), 2) AS prev_month_revenue,
    ROUND(t.monthly_sales - LAG(t.monthly_sales) OVER (ORDER BY t.year, t.month), 2) AS revenue_change,
    ROUND(
        100.0 * (t.monthly_sales - LAG(t.monthly_sales) OVER (ORDER BY t.year, t.month))
        / NULLIF(LAG(t.monthly_sales) OVER (ORDER BY t.year, t.month), 0),
        2
    ) AS mom_growth_percent
FROM (
    SELECT
        d.year,
        d.month,
        SUM(f.sales_amount) AS monthly_sales
    FROM fact_sales f
    JOIN dim_date d ON f.date_id = d.date_id
    GROUP BY d.year, d.month
) t
ORDER BY t.year, t.month;
