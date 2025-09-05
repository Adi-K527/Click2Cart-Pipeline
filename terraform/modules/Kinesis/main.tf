resource "aws_iam_role" "firehose_role" {
  name               = "firehose_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Effect    = "Allow"
      }
    ]
  })
}


resource "aws_kinesis_firehose_delivery_stream" "firehose" {
    name        = var.stream_name
    destination = "extended_s3"

    extended_s3_configuration {
        role_arn   = aws_iam_role.firehose_role.arn
        bucket_arn = var.bucket_arn
        buffering_interval = 1
        buffering_size = 1

        prefix              = "clickstream/"
        error_output_prefix = "errors/"
    }
}