terraform {
    backend "s3" {
        bucket = "click2cart-tf-state-6751"
        key    = "global/s3/terraform.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region = "us-east-1"
}


module "raw_data_bucket" {
    source      = "./modules/S3"
    bucket_name = "click2cart-raw-data-bucket-6751"
}

module "firehose" {
  source      = "./modules/Kinesis"
  stream_name = "click2cart-firehose-stream"
  bucket_arn  = module.raw_data_bucket.bucket_arn
}

module "rds_instance" {
  source      = "./modules/RDS"
  db_password = var.db_password
}

module "sns_topic" {
  source   = "./modules/SNS"
}