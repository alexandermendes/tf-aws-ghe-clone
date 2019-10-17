locals {
  name = replace(join("-", [var.namespace, "clone"]), "/^-/", "")
}

resource "random_password" "webhook_secret" {
  length  = 32
  special = false
}

module "clone_lambda_api" {
  source        = "git::https://github.com/alexandermendes/tf-aws-lambda-api.git?ref=tags/v1.6.5"
  function_name = "clone"
  namespace     = var.namespace
  dir           = "${path.module}/functions"
  ext           = "js"
  runtime       = "nodejs8.10"
  handler       = "handler"
  http_method   = "POST"
  timeout       = 900

  # https://github.com/lambci/git-lambda-layer
  layers      = [
    "arn:aws:lambda:${var.region}:553035198032:layer:git:6"
  ]

  environment = {
    variables = {
      GITHUB_WEBHOOK_SECRET = random_password.webhook_secret.result
      S3_BUCKET             = aws_s3_bucket.bucket.id
    }
  }
}

data "aws_iam_policy_document" "lambda_s3_policy_document" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name   = "${local.name}-s3-policy"
  role   = module.clone_lambda_api.lambda_role_id
  policy = data.aws_iam_policy_document.lambda_s3_policy_document.json
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${local.name}"
  acl    = "private"
}

module "lambda" {
  source        = "git::https://github.com/alexandermendes/tf-aws-lambda-file.git?ref=tags/v2.0.1"
  function_name = "create-webhooks"
  namespace     = var.namespace
  dir           = "${path.module}/functions"
  ext           = "js"
  runtime       = "nodejs8.10"
  handler       = "handler"
}
