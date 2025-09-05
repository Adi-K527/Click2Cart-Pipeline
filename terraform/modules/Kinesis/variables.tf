variable "stream_name" {
  description = "The name of the Kinesis Firehose delivery stream"
  type        = string
}

variable "bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}