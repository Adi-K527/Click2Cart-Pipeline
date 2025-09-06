WITH clickstreams_users_int AS (
    SELECT * FROM {{ ref("int_user_clickstreams") }}
)

SELECT *
FROM clickstreams_users_int