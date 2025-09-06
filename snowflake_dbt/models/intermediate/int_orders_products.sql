WITH 
orders_int AS (
    SELECT * FROM {{ ref("int_orders") }}
),

products_int AS (
    SELECT * FROM {{ ref("int_products") }}
)


SELECT 
    order_id,
    user_id,
    orders.product_id, 
    products.timestamp AS order_date,
    product_name, 
    price,
    stock,
    quantity AS user_purchase_quantity,
    price * quantity AS total_price,
    price * stock AS total_inventory_value, 
FROM orders_int AS orders
INNER JOIN products_int AS products WHERE (orders.product_id = products.product_id)