variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "ec2_name" {
  type = string
}

variable "ami_id" {
  type    = string
  default = "" # empty means module can decide a default
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type    = string
  default = null
}

variable "app_ports" {
  type = list(number)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "cloudwatch_ssm_config_path" {
  type = string
}
