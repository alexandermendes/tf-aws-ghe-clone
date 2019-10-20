output "webhook_url" {
  value       = local.webhook_url
  description = "The webhook URL to invoke the Lambda function"
}

output "webhook_secret" {
  value       = random_password.webhook_secret.result
  description = "The webhook secret."
}

output "s3_id" {
  value       = aws_s3_bucket.bucket.id
  description = "The ID of the S3 bucket to which repos are cloned."
}

output "s3_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "The ARN of the S3 bucket to which repos are cloned."
}
