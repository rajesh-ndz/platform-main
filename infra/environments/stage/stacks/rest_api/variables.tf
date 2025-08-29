variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "integration_base_path" {
  type    = string
  default = ""
}

variable "use_https" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}


