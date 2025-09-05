from airflow.providers.amazon.aws.hooks.kinesis import FirehoseHook
import random
import json

def stream_to_kinesis():
    firehose_hook = FirehoseHook(aws_conn_id='aws_conn_id', delivery_stream='click2cart-firehose-stream')

    record = {
        "user_id": random.randint(1, 100),
        "event": "click",
        "timestamp": "2025-09-04T22:30:00Z"
    }

    for i in range(200):
        if i % 10 == 0:
            print(f"Iteration: {i}")


        firehose_record = {
            "Data": json.dumps(record) + "\n"
        }

        firehose_hook.put_records([firehose_record])