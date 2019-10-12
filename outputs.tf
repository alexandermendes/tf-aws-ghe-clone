output "webhook_url" {
  value       = module.lambda_api.invoke_url
  description = "The webhook URL to invoke the Lambda function"
}

output "webhook_secret" {
  value       = random_password.webhook_secret.result
  description = "The webhook secret."
}
