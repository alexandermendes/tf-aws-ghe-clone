resource "random_password" "webhook_secret" {
  length = 32
}

module "lambda_api" {
  source      = "git::https://github.com/alexandermendes/tf-aws-lambda-api.git?ref=tags/v1.4.0"
  name        = "clone-ghe-repo"
  dir         = "${path.module}/functions"
  ext         = "js"
  runtime     = "nodejs8.10"
  handler     = "handler"
  http_method = "POST"

  # https://github.com/lambci/git-lambda-layer
  layers      = [
    "arn:aws:lambda:${var.region}:553035198032:layer:git:6"
  ]

  environment = {
    variables = {
      GITHUB_WEBHOOK_SECRET = random_password.webhook_secret.result
    }
  }
}
