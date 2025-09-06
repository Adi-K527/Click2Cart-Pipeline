import subprocess

PROJECT_DIR = "/mnt/c/Users/adika/OneDrive/Desktop/deprojects/snowflake-project/Click2Cart-Pipeline/snowflake_dbt"

def run_dbt_workflow():
    subprocess.run(["dbt", "run", "--project-dir", PROJECT_DIR, "--target", "dev"], check=True)
    subprocess.run(["dbt", "snapshot", "--project-dir", PROJECT_DIR], check=True)


def run_dbt_tests():
    subprocess.run(["dbt", "test", "--project-dir", PROJECT_DIR, "--target", "dev"], check=True)