WITH int_products AS (
    SELECT * FROM {{ ref("int_products") }}
)

SELECT *
FROM int_products