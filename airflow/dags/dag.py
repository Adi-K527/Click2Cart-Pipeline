import os
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), '../tasks'))

from datetime import datetime, timedelta
from airflow import DAG
from airflow.utils.task_group import TaskGroup
from airflow.operators.python import PythonOperator
from airflow.utils.trigger_rule import TriggerRule
from dump_rds import dump_rds_to_s3
from load_into_snowflake import load_data_to_snowflake
from run_dbt import run_dbt_workflow, run_dbt_tests
from stream_to_kinesis import stream_to_kinesis
from test_conditions import notify_on_test_fail, export_to_csv


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG (
    'full_pipeline',
    default_args=default_args,
    description='DAG to execute full data pipeline',
    start_date=datetime(2025, 9, 5),
    schedule = "*/10 * * * *",
    catchup=False,
) as dag:

    with TaskGroup("extract_load") as extract_load_group: 
        dump_rds_task = PythonOperator(
            task_id = "dump_rds_task",
            python_callable = dump_rds_to_s3
        )

        stream_to_kinesis_task = PythonOperator(
            task_id = "stream_data_to_kinesis",
            python_callable = stream_to_kinesis
        )

        load_data_to_snowflake_task = PythonOperator(
            task_id = "load_data_to_snowflake_task",
            python_callable = load_data_to_snowflake
        )

        [dump_rds_task, stream_to_kinesis_task] >> load_data_to_snowflake_task


    with TaskGroup("transform") as transform_group:
        run_dbt_task = PythonOperator(
            task_id = "run_dbt_task",
            python_callable = run_dbt_workflow
        )

        run_dbt_tests_task = PythonOperator(
            task_id = "run_dbt_tests_task",
            python_callable = run_dbt_tests
        )

        notify_failure_task = PythonOperator(
            task_id = "notify_failure_task",
            python_callable = notify_on_test_fail,
            trigger_rule = TriggerRule.ONE_FAILED
        )

        export_to_csv_task = PythonOperator(
            task_id = "export_to_csv_task",
            python_callable = export_to_csv,
        )

        run_dbt_task >> run_dbt_tests_task >> [notify_failure_task, export_to_csv_task]

    extract_load_group >> transform_group