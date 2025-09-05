import psycopg2
import boto3
import json
import time
import random
from datetime import datetime, timedelta
import pandas as pd

print("connecting to the database...")
connection = psycopg2.connect(
    database="click2cartDB",
    user="click2cart",
    password="admin123",
    host="terraform-20250904220125760600000001.chz60xl9cvsm.us-east-1.rds.amazonaws.com",
    port=5432
)
cursor = connection.cursor()

print("connected")
cursor.execute("DROP TABLE IF EXISTS orders")
cursor.execute("DROP TABLE IF EXISTS users")
cursor.execute("DROP TABLE IF EXISTS products")


cursor.execute(""" 
    CREATE TABLE IF NOT EXISTS users (
        user_id SERIAL PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS products (
        product_id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        description TEXT,
        price DECIMAL(10, 2) NOT NULL,
        stock INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS orders (
        order_id SERIAL PRIMARY KEY,
        user_id INT REFERENCES users(user_id),
        product_id INT NOT NULL,
        quantity INT NOT NULL,
        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (product_id) REFERENCES products(product_id),
        FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
""")
print("created tables")

def load_csv_to_table(csv_file, table_name):
    with open(csv_file, "r", encoding="utf-8") as f:
        cursor.copy_expert(f"""
            COPY {table_name} FROM STDIN WITH CSV HEADER DELIMITER ','
        """, f)
    connection.commit()
    print(f"✅ Loaded {csv_file} into {table_name}")


load_csv_to_table("users_100.csv", "users")
load_csv_to_table("products_35.csv", "products")
print("loaded csv data")

for _ in range(200):
    user_id = random.randint(1, 100)        # assuming you have 100 users
    product_id = random.randint(1, 35)      # since you created 35 products
    quantity = random.randint(1, 5)         # small order sizes
    order_date = datetime.now() - timedelta(days=random.randint(0, 180))  # past 6 months

    cursor.execute("""
        INSERT INTO orders (user_id, product_id, quantity, order_date)
        VALUES (%s, %s, %s, %s)
    """, (user_id, product_id, quantity, order_date))
print("loaded products data")

connection.commit()
cursor.close()
connection.close()

print("done")