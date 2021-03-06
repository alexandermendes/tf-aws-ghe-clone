locals {
  name        = replace(join("-", [var.namespace, "clone"]), "/^-/", "")
  webhook_url = "${module.clone_lambda_api.invoke_url}/webhook"
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
  ext           = "py"
  runtime       = "python3.7"
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
      GITHUB_TOKEN          = var.github_token,
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

  versioning {
    enabled = true
  }
}

module "lambda" {
  source        = "git::https://github.com/alexandermendes/tf-aws-lambda-file.git?ref=tags/v2.0.1"
  function_name = "create-webhooks"
  namespace     = var.namespace
  dir           = "${path.module}/functions"
  ext           = "py"
  runtime       = "python3.7"
  handler       = "handler"
  environment = {
    variables = {
      REPOSITORIES    = jsonencode(var.repositories),
      GITHUB_API_URL  = var.github_api_url,
      GITHUB_USERNAME = var.github_username,
      GITHUB_TOKEN    = var.github_token,
      WEBHOOK_URL     = local.webhook_url
      WEBHOOK_SECRET  = random_password.webhook_secret.result
    }
  }
}

resource "aws_cloudwatch_event_rule" "scheduled_event" {
    name                = "trigger-${local.name}"
    description         = "A scheduled event to trigger the clone Lambda function"
    schedule_expression = var.create_webhooks_schedule_expression
}

resource "aws_cloudwatch_event_target" "check_foo_every_five_minutes" {
    rule = aws_cloudwatch_event_rule.scheduled_event.name
    arn  = module.lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = module.lambda.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.scheduled_event.arn
}
