resource "random_password" "webhook_secret" {
  length = 32
  special = true
}

module "lambda_api" {
  source      = "git::https://github.com/alexandermendes/tf-aws-lambda-api.git?ref=tags/v1.3.1"
  name        = "clone_ghe_repo"
  dir         = "${path.module}/functions"
  ext         = "py"
  runtime     = "python3.7"
  handler     = "lambda_handler"
  http_method = "POST"
  environment = {
    variables = {
      GITHUB_WEBHOOK_SECRET = random_password.webhook_secret.result
    }
  }
}
