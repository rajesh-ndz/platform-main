variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "repositories" {
  type = list(string)
}

variable "image_tag_mutability" {
  type    = string
  default = "IMMUTABLE"
}

variable "keep_last_images" {
  type    = number
  default = 30
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
