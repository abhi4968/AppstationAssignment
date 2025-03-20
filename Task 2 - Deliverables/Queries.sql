-- Using the required database
use appstationdb;

-- Creating sales table
CREATE TABLE sales (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(50),
    quantity INT CHECK (quantity >= 0), 
    date DATE NOT NULL,
    region VARCHAR(50),
    product_id VARCHAR(20),
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_price DECIMAL(10,2),
    total_value DECIMAL(12,2)
);

SELECT * FROM SALES;

-- Creating products table
CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(50),
    product_price DECIMAL(10,2) NOT NULL
);

-- Creating customers table
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100) DEFAULT 'Unknown'
);

-- Creating transactions table
CREATE TABLE transactions (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(50),  -- Foreign Key
    product_id VARCHAR(20),   -- Foreign Key
    quantity INT CHECK (quantity >= 0),
    date DATE NOT NULL,
    region VARCHAR(50),
    total_value DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Adding an index on frequently queried fields (e.g., date or region).
CREATE INDEX idx_date ON transactions(date);
CREATE INDEX idx_region ON transactions(region);
CREATE INDEX idx_total_value ON transactions(total_value);

-- inserting data into products table from sales table
INSERT INTO products (product_id, product_name, product_category, product_price)
SELECT DISTINCT product_id, product_name, product_category, product_price
FROM sales;

SELECT * FROM products LIMIT 10;

-- inserting data into customers table from sales table
INSERT INTO customers (customer_id)
SELECT DISTINCT customer_id FROM sales
WHERE customer_id IS NOT NULL;

SELECT * FROM customers LIMIT 10;

-- inserting data into transactions table from sales table
INSERT INTO transactions (transaction_id, customer_id, product_id, quantity, date, region, total_value)
SELECT transaction_id, customer_id, product_id, quantity, date, region, total_value
FROM sales;

SELECT * FROM transactions LIMIT 10;

# Total Sales Value by Region
SELECT region, SUM(total_value) AS total_sales
FROM transactions
GROUP BY region
ORDER BY total_sales DESC;

#Top 5 Products by Total Sales Value
SELECT p.product_name, SUM(t.total_value) AS total_sales
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 5;

# Monthly Sales Trends (Total Sales per Month)
SELECT DATE_FORMAT(date, '%Y-%m') AS month, SUM(total_value) AS total_sales
FROM transactions
GROUP BY month
ORDER BY month;










