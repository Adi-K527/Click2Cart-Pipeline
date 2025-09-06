WITH products_staged AS (
    SELECT * FROM {{ ref("src_products") }}
    WHERE stock > 0
)


SELECT 
    product_id,
    UPPER(name) AS product_name,
    price,
    stock,
    price * stock AS total_inventory_value,
    DATE_TRUNC('SECOND', timestamp::TIMESTAMP_NTZ) AS timestamp
FROM products_staged