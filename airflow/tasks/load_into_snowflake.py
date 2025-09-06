from airflow import DAG
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from datetime import datetime


def load_data_to_snowflake():
    hook = SnowflakeHook(snowflake_conn_id="snowflake_conn_id")

    sql_file_path = "/mnt/c/Users/adika/OneDrive/Desktop/deprojects/snowflake-project/Click2Cart-Pipeline/snowflake_dbt/load_data.sql"
    with open(sql_file_path, "r") as f:
        sql = f.read()

    hook.run(sql)
    print("Data loaded into Snowflake successfully!")