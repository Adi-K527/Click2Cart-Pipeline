SELECT * 
FROM {{ ref("fact_orders") }}
WHERE (user_id, order_date) IN (
    SELECT user_id, order_date
    FROM {{ ref("fact_orders") }}
    GROUP BY (user_id, order_date)
    HAVING COUNT(*) > 5
)