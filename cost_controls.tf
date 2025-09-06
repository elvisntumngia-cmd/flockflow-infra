# cost_controls.tf

# Alert if the S3 bucket grows beyond 1GB
resource "aws_cloudwatch_metric_alarm" "s3_storage_alarm" {
  alarm_name          = "HighS3StorageUsage"
  alarm_description   = "Alert if S3 bucket grows beyond 1GB"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = 86400  # check daily
  statistic           = "Average"
  threshold           = 1000000000  # 1 GB
  treat_missing_data  = "missing"

  dimensions = {
    BucketName  = "flockflow-frontend"
    StorageType = "StandardStorage"
  }

  actions_enabled = false
}
