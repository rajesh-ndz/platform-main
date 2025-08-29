# No "region" here; the stack sets the provider region.

variable "env_name" {
  type        = string
  description = "Environment name (e.g., stage, prod)"
}

variable "bucket_base_name" {
  type        = string
  description = "Base bucket name; final name becomes <bucket_base_name>-<env_name> unless overridden"
}

variable "bucket_name_override" {
  type        = string
  default     = null
  description = "Optional fixed bucket name. If set, overrides the derived <base>-<env> name"
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256" # or "aws:kms"
  description = "Server-side encryption algorithm"
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ID/ARN, required only when sse_algorithm = aws:kms"
}

variable "versioning" {
  type        = bool
  default     = true
  description = "Enable S3 bucket versioning"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allow bucket to be destroyed even if it has objects"
}

variable "enable_ia_transition" {
  type        = bool
  default     = false
  description = "Enable transition of current objects to STANDARD_IA"
}

variable "ia_after_days" {
  type        = number
  default     = 30
  description = "Days before transitioning current objects to STANDARD_IA (when enabled)"
}

variable "noncurrent_expire_days" {
  type        = number
  default     = 90
  description = "Days to keep noncurrent versions before expiration"
}

variable "expire_after_days" {
  type        = number
  default     = 0
  description = "0 disables current-object expiration; otherwise expire current objects after this many days"
}

variable "create_ssm_params" {
  type        = bool
  default     = true
  description = "Publish bucket name/ARN into SSM Parameter Store"
}

variable "ssm_path_prefix" {
  type        = string
  default     = "/idlms"
  description = "SSM parameter path prefix for published values"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional resource tags"
}
