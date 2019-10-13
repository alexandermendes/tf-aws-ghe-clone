variable "namespace" {
  description = "A namespace used to prefix resources."
}

variable "region" {
  description = "The AWS region within which the resource are being created."
}

variable "github_repo" {
  description = "The name of a GitHub repository."
}

variable "github_owner" {
  description = "The owner of the GitHub repository (user or organisation)."
}
