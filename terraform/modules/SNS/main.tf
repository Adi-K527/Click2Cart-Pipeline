resource "aws_sns_topic" "notification_topic" {
  name       = "click2cart-notification-topic"
  fifo_topic = false
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "email"
  endpoint  = "robwindowski@gmail.com"
}