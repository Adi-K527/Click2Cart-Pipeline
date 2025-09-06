WITH clickstreams_int AS (
    SELECT * FROM {{ ref('int_clickstreams') }}
),

users_int AS (
    SELECT * FROM {{ ref('int_users') }}
)

SELECT 
    event_id,
    product_id,
    clickstreams.user_id,
    username,
    action,
    clickstream_timestamp
FROM clickstreams_int AS clickstreams
INNER JOIN users_int AS users ON (clickstreams.user_id = users.user_id)