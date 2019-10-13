locals {
  source_zip_name = "${var.github_repo}.tar.gz"
  name            = replace(join("-", [var.namespace, var.pipeline_name]), "/^-/", "")
}

resource "random_password" "webhook_secret" {
  length = 32
}

module "lambda_api" {
  source        = "git::https://github.com/alexandermendes/tf-aws-lambda-api.git?ref=tags/v1.6.3"
  function_name = "clone"
  namespace     = var.namespace
  dir           = "${path.module}/functions"
  ext           = "js"
  runtime       = "nodejs8.10"
  handler       = "handler"
  http_method   = "POST"
  timeout       = 60

  # https://github.com/lambci/git-lambda-layer
  layers      = [
    "arn:aws:lambda:${var.region}:553035198032:layer:git:6"
  ]

  environment = {
    variables = {
      # TODO: Validate the webhook using all of these things
      GITHUB_WEBHOOK_SECRET = random_password.webhook_secret.result
      GITHUB_REPO           = var.github_repo
      GITHUB_OWNER          = var.github_owner

      S3_BUCKET             = aws_s3_bucket.codepipeline_source_bucket.id
      ZIP_NAME              = local.source_zip_name
    }
  }
}

data "aws_iam_policy_document" "lambda_s3_policy_document" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.codepipeline_source_bucket.arn,
      "${aws_s3_bucket.codepipeline_source_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name   = "${local.name}-clone"
  role   = module.lambda_api.lambda_role_id
  policy = data.aws_iam_policy_document.lambda_s3_policy_document.json
}

resource "aws_s3_bucket" "codepipeline_source_bucket" {
  bucket = "${local.name}-source"
  acl    = "private"
}

resource "aws_s3_bucket" "codepipeline_artifact_bucket" {
  bucket = "${local.name}-artifacts"
  acl    = "private"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${local.name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${local.name}-codepipeline"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_artifact_bucket.arn}",
        "${aws_s3_bucket.codepipeline_artifact_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_key" "key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_codepipeline" "codepipeline" {
  name     = local.name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifact_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.key.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration    = {
        S3Bucket             = aws_s3_bucket.codepipeline_source_bucket.id
        S3ObjectKey          = local.source_zip_name
        PollForSourceChanges = true
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "test"
      }
    }
  }
}
