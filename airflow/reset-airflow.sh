#!/bin/bash

pkill -f airflow
echo "stopped airflow"

export AIRFLOW_HOME="/mnt/c/Users/adika/OneDrive/Desktop/deprojects/snowflake-project/Click2Cart-Pipeline/airflow"
echo "set airflow home path"


source ~/.bashrc
airflow standalone