# Terraform AWS GitHub Enterprise Clone

A Terraform module to create an AWS Lambda function that clones GitHub repositories
to an S3 bucket.

The module runs a second scheduled Lambda function to ensure the GitHub webhooks
are enabled correctly and remain enabled.

One use case is for the contents of this bucket to be used as a source action
for CodePipeline, which cannot integrate directly with on-premises GitHub
Enterprise repositories by default.

## Usage

```terraform
module "clone" {
  source          = "git::https://github.com/alexandermendes/tf-aws-ghe-clone.git?ref=tags/v1.0.0"
  region          = "us-east-1"
  github_username = "alexandermendes"
  github_token    = "my-secret-token"
  repositories    = [
    {
      owner = "Codertocat",
      name  = "Hello-World",
    },
  ]
}
```

**Note that the source reference above is just an example, in most cases you
should update it to the [latest tag](https://github.com/alexandermendes/tf-aws-lambda-api/tags).**

For additional variables and outputs see [variables.tf](./variables.tf) and
[outputs.tf](./outputs.tf), respectively.

### Workflow

When a POST request is made to the API endpoint output via `webhook_url` a
Lambda function is triggered. The function validates the `webhook_secret`, clones
and zips the repository, and stores it in S3 (see `s3_id` and `s3_arn`). The
object key will be the full name of the GitHub repository
(e.g. `Codertocat/Hello-World.tar.gz`).
