from airflow.providers.amazon.aws.hooks.sns import SnsHook
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
import pandas as pd
import os

def notify_on_test_fail():
    sns_hook = SnsHook(aws_conn_id='aws_conn_id')

    sns_hook.publish_to_topic(
        topic_arn="arn:aws:sns:us-east-1:206479108282:click2cart-sns-topic",
        message="dbt tests failed",
        subject="DBT Failure"
    )


def export_to_csv():
    snowflake_hook = SnowflakeHook(snowflake_conn_id = "snowflake_conn_id")

    tables = ["CLICK2CART.DEV.DIM_USERS", "CLICK2CART.DEV.DIM_PRODUCTS", "CLICK2CART.DEV.FACT_ORDERS", "CLICK2CART.DEV.FACT_CLICKSTREAMS"]
    output_dir = "/mnt/c/Users/adika/OneDrive/Desktop/deprojects/snowflake-project/Click2Cart-Pipeline/data"
    os.makedirs(output_dir, exist_ok=True)

    for table in tables:
        sql = f"SELECT * FROM {table}"
        df = snowflake_hook.get_pandas_df(sql) 
        csv_path = os.path.join(output_dir, f"{table}.csv")
        df.to_csv(csv_path, index=False)
        print(f"Exported {table} to {csv_path}")