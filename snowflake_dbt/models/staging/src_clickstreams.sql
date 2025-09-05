WITH raw_clickstreams AS (
    SELECT * FROM CLICK2CART.RAW.RAW_CLICKSTREAMS;
)

SELECT data
FROM raw_clickstreams;