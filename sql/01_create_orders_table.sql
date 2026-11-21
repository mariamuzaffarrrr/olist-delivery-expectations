CREATE DATABASE olist;
USE olist;

CREATE TABLE orders (
  order_id CHAR(32) PRIMARY KEY,
  customer_id CHAR(32) NOT NULL,
  order_status VARCHAR(20) NOT NULL,
  order_purchase_timestamp DATETIME,
  order_approved_at DATETIME NULL,
  order_delivered_carrier_date DATETIME NULL,
  order_delivered_customer_date DATETIME NULL,
  order_estimated_delivery_date DATETIME
);

SET GLOBAL local_infile = 1;

USE olist;
TRUNCATE TABLE orders;  -- clears any half-loaded rows from the wizard attempts

LOAD DATA LOCAL INFILE 'C:/Users/maria/projects/olist-delivery-expectations/data/raw/olist_orders_dataset.csv'
INTO TABLE orders                         -- which table to fill
FIELDS TERMINATED BY ','                  -- columns are separated by commas
OPTIONALLY ENCLOSED BY '"'                -- some values are wrapped in quotes
LINES TERMINATED BY '\n'                  -- each row ends with a line break
IGNORE 1 LINES                            -- skip the header row
(@order_id, @customer_id, @order_status, @purchased, @approved,
 @carrier, @delivered, @estimated)        -- read each column into a temporary variable
SET order_id = @order_id,
    customer_id = @customer_id,
    order_status = @order_status,
    order_purchase_timestamp = NULLIF(@purchased, ''),   -- empty text becomes a real NULL
    order_approved_at = NULLIF(@approved, ''),
    order_delivered_carrier_date = NULLIF(@carrier, ''),
    order_delivered_customer_date = NULLIF(@delivered, ''),
    order_estimated_delivery_date = NULLIF(REPLACE(@estimated, '\r', ''), '');
    -- REPLACE removes a hidden Windows line-break character stuck to the last column
    
SELECT COUNT(*) FROM orders;   -- should be 99441
SELECT * FROM orders LIMIT 5;