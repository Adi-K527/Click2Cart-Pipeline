WITH users_int AS (
    SELECT * FROM {{ ref("int_users") }}
)

SELECT *
FROM users_int