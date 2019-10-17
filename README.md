# Terraform AWS GitHub Enterprise Clone

A Terraform module to create an AWS Lambda function that clones GitHub repositories
to an S3 bucket.

One use case is for the contents of this bucket to be used as a source action
for CodePipeline, which cannot integrate directly with on-premises GitHub
Enterprise repositories by default.

## Usage

```terraform
module "clone" {
  source = "git::https://github.com/alexandermendes/tf-aws-ghe-clone.git?ref=tags/v1.0.0"
  region = "us-east-1"

}
```

**Note that the source reference above is just an example, in most cases you
should update it to the [latest tag](https://github.com/alexandermendes/tf-aws-lambda-api/tags).**

For additional variables and outputs see [variables.tf](./variables.tf) and
[outputs.tf](./outputs.tf), respectively.
