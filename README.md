# Click2Cart
---

In this data engineering project, I aimed to build an ELT pipeline using AWS, Snowflake and DBT, with PowerBI at the final analysis stage. Artificially generated organizational data was used, and involved a users, products and orders table. Additionally, artificially generated clickstream data was produced in real time, and both the organizational data along with this clickstream data were used in this pipeline to gather insights and drive analytics.

</br></br>
### High Level Architecture
---
<img width="1115" height="335" alt="image" src="https://github.com/user-attachments/assets/c67631d7-b159-407e-b848-fa3a63b9d57d" />

</br>

This Airflow DAG consisted of 2 task groups. The first was the "extract_load" group which first produces data into the kinesis stream which delivers to S3, and dumps table data from RDS into S3 in parallel. Then it loads the data from S3 into Snowflake using the load_data.sql file. The next task group was the "Transform" group which ran the dbt transformation workflow along with creating snapshots, and performed testing afterwards. The end results of the transformations were stored in the DEV schema of the database and were loaded from Snowflake directly as csv files, enabling PowerBI to create visualizations of the data.

</br></br>

<img width="1021" height="570" alt="image" src="https://github.com/user-attachments/assets/5d55b60e-31a0-4164-ac3c-38e7dcd8a0d2" />

</br></br>
### Conclusion
---
Overall, this project served to offer fundamental experience in building an end-to-end ELT pipeline with AWS, Snowflake, and DBT.

