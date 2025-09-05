WITH orders_int AS (
    SELECT * FROM {{ ref(int_orders) }}
)

WITH products_int AS (
    SELECT * FROM {{ ref(int_products) }}
)


SELECT 
    *
FROM orders_int AS orders
INNER JOIN products_int AS products WHERE (orders.product_id = products.product_id)