from airflow.providers.amazon.aws.hooks.kinesis import FirehoseHook
import random
import json
import uuid
from datetime import datetime, timedelta

def produce_timestamp():
    now = datetime.utcnow()
    random_days = random.randint(0, 29)
    random_seconds = random.randint(0, 86399)  # seconds in a day
    random_time = now - timedelta(days=random_days, seconds=random_seconds)
    return random_time.strftime("%Y-%m-%dT%H:%M:%SZ")


def stream_to_kinesis():
    firehose_hook = FirehoseHook(aws_conn_id='aws_conn_id', delivery_stream='click2cart-firehose-stream')


    for i in range(200):
        actions = ["view_product", "add_to_cart", "remove_from_cart", "search", "checkout_start"]
        record  = {
            "event_id": str(uuid.uuid4()),
            "user_id": random.randint(1, 100),
            "product_id": random.randint(1, 35),
            "event": random.choice(actions),
            "timestamp": produce_timestamp()
        }
    
        if i % 10 == 0:
            print(f"Iteration: {i}")

        firehose_record = {
            "Data": json.dumps(record) + "\n"
        }

        firehose_hook.put_records([firehose_record])