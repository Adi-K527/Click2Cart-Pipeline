WITH users_staged AS (
    SELECT * FROM {{ ref('src_users') }}
)

SELECT *
FROM users_staged