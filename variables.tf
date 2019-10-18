variable "namespace" {
  description = "A namespace to be prepended to resource names."
  default     = ""
}

variable "region" {
  description = "The AWS region within which the resource are being created."
}

variable "repositories" {
  description = "A list of repositories for which to generate the webhooks."
  default     = null
  type = list(object({
    name  = string
    owner = string
  }))
}

variable "github_username" {
  description = "The username of a GitHub user."
}

variable "github_token" {
  description = "An access token for the GitHub user with the `admin:repo_hook` and `repo` scopes."
}

variable "github_api_url" {
  description = "The URL of the GitHub API."
  default     = "https://api.github.com/"
}
