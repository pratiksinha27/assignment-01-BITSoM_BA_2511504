-- Q1: List all customers along with the total number of orders they have placed

SELECT 
c.customer_id,
c.customer_name,
COUNT(o.order_id) AS total_orders
FROM read_csv_auto('datasets/customers.csv') c
LEFT JOIN read_json_auto('datasets/orders.json') o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;


-- Q2: Find the top 3 customers by total order value

SELECT 
c.customer_name,
SUM(o.total_amount) AS total_spent
FROM read_csv_auto('datasets/customers.csv') c
JOIN read_json_auto('datasets/orders.json') o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 3;


-- Q3: List all products purchased by customers from Mumbai

SELECT
c.customer_name,
p.product_name
FROM read_csv_auto('datasets/customers.csv') c
JOIN read_json_auto('datasets/orders.json') o
ON c.customer_id = o.customer_id
JOIN 'datasets/products.parquet' p
ON o.product_id = p.product_id
WHERE c.city = 'Mumbai';


-- Q4: Join all three files to show: customer name, order date, product name, and quantity

SELECT 
c.customer_name,
o.order_date,
p.product_name,
o.quantity
FROM read_csv_auto('datasets/customers.csv') c
JOIN read_json_auto('datasets/orders.json') o
ON c.customer_id = o.customer_id
JOIN 'datasets/products.parquet' p
ON o.product_id = p.product_id;