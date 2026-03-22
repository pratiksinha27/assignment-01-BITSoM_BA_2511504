-- ============================================================
-- Part 5 — Data Lake & DuckDB: Cross-Format Queries
-- Reads directly from raw files — no pre-loading into tables
--
-- Verified schema:
--   customers.csv    : customer_id, name, city, signup_date, email
--   orders.json      : order_id, customer_id, order_date, status, total_amount, num_items
--   products.parquet : line_item_id, order_id, product_id, product_name, category,
--                      quantity, unit_price, total_price
-- ============================================================

-- Q1: List all customers along with the total number of orders they have placed
SELECT
    c.customer_id,
    c.name                AS customer_name,
    c.city,
    COUNT(o.order_id)     AS total_orders
FROM read_csv_auto('datasets/customers.csv') AS c
LEFT JOIN read_json_auto('datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_orders DESC;


-- Q2: Find the top 3 customers by total order value
SELECT
    c.customer_id,
    c.name                        AS customer_name,
    c.city,
    ROUND(SUM(o.total_amount), 2) AS total_order_value,
    COUNT(o.order_id)             AS number_of_orders
FROM read_csv_auto('datasets/customers.csv') AS c
JOIN read_json_auto('datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_order_value DESC
LIMIT 3;


-- Q3: List all products purchased by customers from Bangalore
-- Note: products.parquet is a line-items table joined via order_id
SELECT DISTINCT
    c.name         AS customer_name,
    c.city,
    p.product_name,
    p.category,
    p.quantity,
    p.unit_price
FROM read_csv_auto('datasets/customers.csv') AS c
JOIN read_json_auto('datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
JOIN read_parquet('datasets/products.parquet') AS p
    ON o.order_id = p.order_id
WHERE LOWER(TRIM(c.city)) = 'bangalore'
ORDER BY c.name, p.product_name;


-- Q4: Join all three files to show: customer name, order date, product name, and quantity
SELECT
    c.name         AS customer_name,
    o.order_date,
    p.product_name,
    p.quantity
FROM read_csv_auto('datasets/customers.csv') AS c
JOIN read_json_auto('datasets/orders.json') AS o
    ON c.customer_id = o.customer_id
JOIN read_parquet('datasets/products.parquet') AS p
    ON o.order_id = p.order_id
ORDER BY o.order_date DESC, c.name;
