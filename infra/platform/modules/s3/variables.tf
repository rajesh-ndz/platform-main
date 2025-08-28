variable "bucket_name" {
  description = "Full S3 bucket name (must be globally unique, lowercase)"
  type        = string
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "block_public_access" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Optional SSM parameters to publish bucket details
variable "ssm_param_bucket_name" {
  description = "If set, write the bucket name to this SSM parameter path"
  type        = string
  default     = null
}

variable "ssm_param_bucket_arn" {
  description = "If set, write the bucket ARN to this SSM parameter path"
  type        = string
  default     = null
}
