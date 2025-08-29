variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "internal" {
  type = bool
}

variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}

variable "target_port" {
  type = number
}

variable "target_protocol" {
  type = string
}

variable "target_type" {
  type = string
}

variable "target_instance_ids" {
  type    = list(string)
  default = []
}

variable "target_ips" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

