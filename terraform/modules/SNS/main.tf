resource "aws_sns_topic" "notification_topic" {
  name       = var.topic_name
  fifo_topic = false
}

resource "aws_sns_topic_policy" "allow_s3_publish" {
  arn    = aws_sns_topic.notification_topic.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowS3Publish"
      Effect    = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
      Action    = "SNS:Publish"
      Resource  = aws_sns_topic.notification_topic.arn
    },
    {
      Sid       = "AllowSubscription"
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::400036641526:root" }
      Action    = "SNS:Subscribe"
      Resource  = aws_sns_topic.notification_topic.arn
    }]
  })
}
