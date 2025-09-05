WITH clickstreams_staged AS (
    SELECT * FROM {{ ref('src_clickstreams') }}
)

SELECT 
    DATA['event_id']::STRING AS event_id,
    DATA['user_id']::INT AS user_id,
    DATA['product_id']::INT AS product_id,
    INITCAP(DATA['event'])::STRING AS action,
    DATE_TRUNC('SECOND', DATA['timestamp']::TIMESTAMP_NTZ) AS timestamp,
FROM raw.raw_clickstreams AS rc