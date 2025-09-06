from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
import csv

def dump_rds_to_s3():
    rds_hook = PostgresHook(postgres_conn_id='postgres_conn_id')
    s3_hook = S3Hook(aws_conn_id='aws_conn_id')

    bucket_name = 'click2cart-raw-data-bucket-6751'
    s3_key = 'customers_data'
    local_file_path = '/tmp'

    tables = ["users", "orders", "products"]

    conn = rds_hook.get_conn()
    for table in tables:
        cur = conn.cursor()
        cur.execute(f"SELECT * FROM {table}")
        records = cur.fetchall()
        columns = [desc[0] for desc in cur.description]

        local_csv = f"{local_file_path}/{table}.csv"
        with open(local_csv, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(columns)
            writer.writerows(records)

        s3_hook.load_file(
            filename=local_csv,
            key=f"{s3_key}/{table}.csv",
            bucket_name=bucket_name,
            replace=True
        )
    print(f"Dumped RDS database to {bucket_name}/{s3_key}")
