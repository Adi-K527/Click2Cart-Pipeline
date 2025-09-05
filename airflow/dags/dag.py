import os
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), '../tasks'))

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from dump_rds import dump_rds_to_s3
from stream_to_kinesis import stream_to_kinesis


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}


with DAG(
    'dump_data_to_s3',
    default_args=default_args,
    description='Test DAG to dump RDS data to S3',
    start_date=datetime(2025, 9, 5),
    catchup=False,
) as dag:

    task1 = PythonOperator(
        task_id='dump_rds_to_s3',
        python_callable=dump_rds_to_s3
    )


with DAG(
    'stream_data_to_kinesis',
    default_args=default_args,
    description='Test DAG to stream data to Kinesis',
    start_date=datetime(2025, 9, 5),
    catchup=False,
) as dag:

    task1 = PythonOperator(
        task_id='stream_to_kinesis',
        python_callable=stream_to_kinesis
    )