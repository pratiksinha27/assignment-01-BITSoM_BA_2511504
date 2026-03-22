-- ============================================================
-- Part 3 — Star Schema Design
-- Source: retail_transactions.csv
-- ETL applied: dates standardized, NULL store_city filled,
--              category casing standardized to Title Case
-- ============================================================

DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;

-- Dimension: Date
CREATE TABLE dim_date (
    date_id    INT     PRIMARY KEY,  -- YYYYMMDD format
    full_date  DATE    NOT NULL,
    day        INT     NOT NULL,
    month      INT     NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    quarter    INT     NOT NULL,
    year       INT     NOT NULL,
    is_weekend BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO dim_date VALUES
(20230115, '2023-01-15', 15, 1,  'January',   1, 2023, FALSE),
(20230205, '2023-02-05',  5, 2,  'February',  1, 2023, FALSE),
(20230220, '2023-02-20', 20, 2,  'February',  1, 2023, FALSE),
(20230331, '2023-03-31', 31, 3,  'March',     1, 2023, FALSE),
(20230604, '2023-06-04',  4, 6,  'June',      2, 2023, FALSE),
(20230809, '2023-08-09',  9, 8,  'August',    3, 2023, FALSE),
(20230815, '2023-08-15', 15, 8,  'August',    3, 2023, FALSE),
(20230829, '2023-08-29', 29, 8,  'August',    3, 2023, FALSE),
(20231020, '2023-10-20', 20, 10, 'October',   4, 2023, FALSE),
(20231026, '2023-10-26', 26, 10, 'October',   4, 2023, FALSE),
(20231208, '2023-12-08',  8, 12, 'December',  4, 2023, FALSE),
(20231212, '2023-12-12', 12, 12, 'December',  4, 2023, FALSE);

-- Dimension: Store
-- ETL Fix: 19 rows had NULL store_city; filled from store_name lookup
CREATE TABLE dim_store (
    store_id   INT          PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city       VARCHAR(50)  NOT NULL,
    region     VARCHAR(20)  NOT NULL
);

INSERT INTO dim_store VALUES
(1, 'Chennai Anna',    'Chennai',   'South'),
(2, 'Delhi South',     'Delhi',     'North'),
(3, 'Bangalore MG',    'Bangalore', 'South'),
(4, 'Pune FC Road',    'Pune',      'West'),
(5, 'Mumbai Central',  'Mumbai',    'West');

-- Dimension: Product
-- ETL Fix: 'electronics' -> 'Electronics', 'Grocery' -> 'Groceries'
CREATE TABLE dim_product (
    product_id   INT          PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category     VARCHAR(50)  NOT NULL   -- standardized to Title Case
);

INSERT INTO dim_product VALUES
(1, 'Speaker',    'Electronics'),
(2, 'Tablet',     'Electronics'),
(3, 'Phone',      'Electronics'),
(4, 'Smartwatch', 'Electronics'),
(5, 'Laptop',     'Electronics'),
(6, 'Headphones', 'Electronics'),
(7, 'Jeans',      'Clothing'),
(8, 'Jacket',     'Clothing'),
(9, 'T-Shirt',    'Clothing'),
(10,'Biscuits',   'Groceries'),
(11,'Milk 1L',    'Groceries'),
(12,'Atta 10kg',  'Groceries');

-- Fact Table: fact_sales
-- Grain: one row per transaction from retail_transactions.csv
CREATE TABLE fact_sales (
    sale_id        INT PRIMARY KEY,
    transaction_id VARCHAR(20)    NOT NULL,
    date_id        INT            NOT NULL,
    store_id       INT            NOT NULL,
    product_id     INT            NOT NULL,
    quantity       INT            NOT NULL,
    unit_price     DECIMAL(12,2)  NOT NULL,
    sales_amount   DECIMAL(14,2)  NOT NULL,  -- quantity * unit_price
    FOREIGN KEY (date_id)    REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id)   REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- 12 fact rows — real cleaned data from retail_transactions.csv
-- ETL: dates parsed to ISO, store_city NULLs filled, category casing fixed
INSERT INTO fact_sales VALUES
(1,  'TXN5000', 20230829, 1, 1,  3,  49262.78, 147788.34),
(2,  'TXN5001', 20231212, 1, 2,  11, 23226.12, 255487.32),
(3,  'TXN5002', 20230205, 1, 3,  20, 48703.39, 974067.80),
(4,  'TXN5003', 20230220, 2, 2,  14, 23226.12, 325165.68),
(5,  'TXN5004', 20230115, 1, 4,  10, 58851.01, 588510.10),
(6,  'TXN5005', 20230809, 3, 12, 12, 52464.00, 629568.00),
(7,  'TXN5006', 20230331, 4, 4,  6,  58851.01, 353106.06),
(8,  'TXN5007', 20231026, 4, 7,  16,  2317.47,  37079.52),
(9,  'TXN5008', 20231208, 3, 10, 9,  27469.99, 247229.91),
(10, 'TXN5009', 20230815, 3, 4,  3,  58851.01, 176553.03),
(11, 'TXN5010', 20230604, 1, 8,  15, 30187.24, 452808.60),
(12, 'TXN5011', 20231020, 5, 7,  13,  2317.47,  30127.11);
