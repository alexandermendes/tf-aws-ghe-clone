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
