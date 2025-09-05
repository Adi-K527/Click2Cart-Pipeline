WITH raw_products AS (
    SELECT * FROM CLICK2CART.RAW.RAW_PRODUCTS
)

SELECT 
    product_id, 
    name, 
    description, 
    price, 
    stock, 
    created_at as timestamp
FROM raw_products