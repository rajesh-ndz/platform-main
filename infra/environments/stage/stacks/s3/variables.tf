variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "bucket_base_name" {
  type = string
}

variable "versioning" {
  type    = bool
  default = true
}

variable "sse_algorithm" {
  type    = string
  default = "AES256"
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
