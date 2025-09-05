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
    sns_arn     = module.sns_s3_topic.arn
    depends_on = [ module.sns_s3_topic ]
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
  topic_name = "click2cart-sns-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = module.sns_topic.arn
  protocol  = "email"
  endpoint  = "robwindowski@gmail.com"
}

module "sns_s3_topic" {
  source   = "./modules/SNS"
  topic_name = "s3_topic"
}