WITH raw_orders AS (
    SELECT * FROM CLICK2CART.RAW.RAW_ORDERS;
)

SELECT 
    order_id, 
    user_id, 
    product_id, 
    quantity, 
    order_date
FROM raw_orders;