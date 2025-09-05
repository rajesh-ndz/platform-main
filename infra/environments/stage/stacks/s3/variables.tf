variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "bucket_name_override" {
  type        = string
  default     = ""
  description = "If set, use this exact bucket name."
}

variable "tags" {
  type    = map(string)
  default = {}
}
