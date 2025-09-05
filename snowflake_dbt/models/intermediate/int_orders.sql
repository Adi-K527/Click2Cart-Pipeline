WITH orders_staged AS (
    SELECT * FROM {{ ref(src_orders) }}
)


WITH orders_intermediate AS (
    SELECT 
        order_id,
        user_id,
        product_id,
        quantity,
        DATE_TRUNC('SECOND', order_date::TIMESTAMP_NTZ) AS order_timestamp
    FROM orders_staged
)

SELECT * 
FROM orders_intermediate
WHERE (user_id, order_timestamp) IN (
    SELECT user_id, order_timestamp
    FROM orders_intermediate
    GROUP BY (user_id, order_timestamp)
    HAVING COUNT(*) = 1
)