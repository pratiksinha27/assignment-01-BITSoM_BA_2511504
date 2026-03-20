CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100) NOT NULL,
city VARCHAR(50) NOT NULL
);

CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100) NOT NULL,
price DECIMAL(10,2) NOT NULL
);

CREATE TABLE sales_reps (
rep_id INT PRIMARY KEY,
rep_name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT NOT NULL,
rep_id INT NOT NULL,
order_date DATE,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (rep_id) REFERENCES sales_reps(rep_id)
);

CREATE TABLE order_items (
order_item_id INT PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert Customers

INSERT INTO customers VALUES
(1,'Rahul Sharma','Mumbai'),
(2,'Priya Singh','Delhi'),
(3,'Amit Patel','Ahmedabad'),
(4,'Neha Gupta','Mumbai'),
(5,'Rohan Verma','Pune');

-- Insert Products

INSERT INTO products VALUES
(1,'Laptop',60000),
(2,'Keyboard',1500),
(3,'Mouse',800),
(4,'Monitor',12000),
(5,'USB Cable',200);

-- Insert Sales Reps

INSERT INTO sales_reps VALUES
(1,'Aman'),
(2,'Suresh'),
(3,'Karan'),
(4,'Meena'),
(5,'Rita');

-- Insert Orders

INSERT INTO orders VALUES
(101,1,1,'2024-01-01'),
(102,2,2,'2024-01-02'),
(103,3,3,'2024-01-03'),
(104,4,4,'2024-01-04'),
(105,5,5,'2024-01-05');

-- Insert Order Items

INSERT INTO order_items VALUES
(1,101,1,1),
(2,101,2,2),
(3,102,3,3),
(4,103,4,1),
(5,104,5,5);