USE ROLE ACCOUNTADMIN;

CREATE RESOURCE MONITOR click2cart_rm WITH 
    CREDIT_QUOTA = 15
    FREQUENCY = 'DAILY'
    START_TIMESTAMP = IMMEDIATELY
    TRIGGERS ON 80 PERCENT DO NOTIFY
             ON 90 PERCENT DO SUSPEND
             ON 100 PERCENT DO SUSPEND_IMMEDIATE;

CREATE WAREHOUSE IF NOT EXISTS load_wh
    warehouse_size = 'SMALL',
    auto_suspend = 30,
    auto_resume = TRUE,
    resource_monitor = click2cart_rm;


USE WAREHOUSE load_wh;
USE DATABASE click2cart;
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS dev;

USE SCHEMA raw;

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    created_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS clickstreams (
    data VARIANT
);

CREATE OR REPLACE FILE FORMAT csv_ff
    type = 'csv'
    skip_header = 1;

CREATE OR REPLACE FILE FORMAT json_ff
    type = 'json'
    STRIP_OUTER_ARRAY = TRUE;

CREATE STAGE IF NOT EXISTS db_stage
    url = "s3://click2cart-raw-data-bucket-6751/customers_data"
    FILE_FORMAT = csv_ff;

CREATE OR REPLACE STAGE clickstream_stage
    url = "s3://click2cart-raw-data-bucket-6751/clickstream"
    FILE_FORMAT = json_ff

COPY INTO users
FROM @db_stage/users.csv
FILE_FORMAT = (FORMAT_NAME = csv_ff);

COPY INTO products
FROM @db_stage/products.csv
FILE_FORMAT = (FORMAT_NAME = csv_ff);

COPY INTO orders
FROM @db_stage/orders.csv
FILE_FORMAT = (FORMAT_NAME = csv_ff);

CREATE OR REPLACE PIPE clickstream_pipe 
    AUTO_INGEST = TRUE
    AWS_SNS_TOPIC = 'arn:aws:sns:us-east-1:206479108282:s3_topic'
AS
    COPY INTO clickstreams
    FROM @clickstream_stage/2025
    FILE_FORMAT = (FORMAT_NAME = json_ff);

SELECT * FROM clickstreams;

DROP WAREHOUSE load_wh;
