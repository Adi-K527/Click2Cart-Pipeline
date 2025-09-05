WITH raw_users AS (
    SELECT * FROM CLICK2CART.RAW.RAW_USERS;
)

SELECT 
    user_id, 
    username, 
    email, 
    created_at as timestamp
FROM raw_users;