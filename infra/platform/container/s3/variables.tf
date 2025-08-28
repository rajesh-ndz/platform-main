variable "region" {
  type        = string
  description = "e.g. ap-south-1"
}

variable "environment" {
  type        = string
  description = "e.g. stage"
}

variable "name" {
  type        = string
  description = "e.g. idlms-artifacts"
}

variable "bucket_name_override" {
  type    = string
  default = null
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "Use AES256 or aws:kms"
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "versioning" {
  type    = bool
  default = true
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "enable_ia_transition" {
  type    = bool
  default = false
}

variable "ia_after_days" {
  type    = number
  default = 30
}

variable "noncurrent_expire_days" {
  type    = number
  default = 90
}

variable "expire_after_days" {
  type    = number
  default = 0
}

variable "create_ssm_params" {
  type    = bool
  default = true
}

variable "ssm_path_prefix" {
  type    = string
  default = "/idlms"
}

variable "tags" {
  type    = map(string)
  default = {}
}
