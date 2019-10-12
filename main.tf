module "lambda_api" {
  source      = "git::https://github.com/alexandermendes/tf-aws-lambda-api.git?ref=master"
  name        = "clone_ghe_repo"
  dir         = "${path.module}/functions"
  ext         = "py"
  runtime     = "python3.7"
  handler     = "lambda_handler"
  http_method = "POST"
  path_part   = "webhook"
}
