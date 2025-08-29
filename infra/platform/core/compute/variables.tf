variable "env_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ec2_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type    = string
  default = "" # your module can default if empty
}

variable "key_name" {
  type    = string
  default = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
variable "cloudwatch_ssm_config_path" {
  type = string
}
variable "app_ports" {
  type    = list(number)
  default = []
}
