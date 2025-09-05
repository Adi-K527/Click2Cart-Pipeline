variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "sns_arn" {
  description = "The ARN of the SNS topic to notify on new object creation"
  type        = string
}