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