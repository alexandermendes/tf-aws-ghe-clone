resource "random_password" "webhook_secret" {
  length = 32
}

module "lambda_api" {
  source      = "git::https://github.com/alexandermendes/tf-aws-lambda-api.git?ref=tags/v1.3.1"
  name        = "clone-ghe-repo"
  dir         = "${path.module}/functions"
  ext         = "js"
  runtime     = "nodejs8.10"
  handler     = "handler"
  http_method = "POST"
  environment = {
    variables = {
      GITHUB_WEBHOOK_SECRET = random_password.webhook_secret.result
    }
  }
}
