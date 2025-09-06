WITH orders_products_int AS (
    SELECT * FROM {{ ref("int_orders_products") }}
)

SELECT *
FROM orders_products_int