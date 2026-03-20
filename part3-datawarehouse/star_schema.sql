-- Dimension Table: Date

CREATE TABLE dim_date (
date_id INT PRIMARY KEY,
full_date DATE NOT NULL,
month INT NOT NULL,
year INT NOT NULL
);

-- Dimension Table: Store

CREATE TABLE dim_store (
store_id INT PRIMARY KEY,
store_name VARCHAR(100),
city VARCHAR(100)
);

-- Dimension Table: Product

CREATE TABLE dim_product (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(100)
);

-- Fact Table

CREATE TABLE fact_sales (
sale_id INT PRIMARY KEY,
date_id INT,
store_id INT,
product_id INT,
quantity INT,
sales_amount DECIMAL(10,2),

FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- Insert into dim_date (cleaned dates)

INSERT INTO dim_date VALUES
(1,'2023-01-01',1,2023),
(2,'2023-02-01',2,2023),
(3,'2023-03-01',3,2023),
(4,'2023-04-01',4,2023),
(5,'2023-05-01',5,2023);

-- Insert into dim_store

INSERT INTO dim_store VALUES
(1,'Store A','Mumbai'),
(2,'Store B','Delhi'),
(3,'Store C','Bangalore');

-- Insert into dim_product (category standardized)

INSERT INTO dim_product VALUES
(1,'Laptop','Electronics'),
(2,'T-shirt','Clothing'),
(3,'Rice','Groceries');

-- Insert sample fact rows (10 rows)

INSERT INTO fact_sales VALUES
(1,1,1,1,2,120000),
(2,1,2,2,5,5000),
(3,2,1,3,10,8000),
(4,2,3,1,1,60000),
(5,3,2,2,4,4000),
(6,3,3,3,8,6000),
(7,4,1,1,3,180000),
(8,4,2,3,6,4500),
(9,5,3,2,7,7000),
(10,5,1,3,5,3500);