variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "ec2_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type    = string
  default = ""
}

variable "key_name" {
  type    = string
  default = null
}

# variable "allow_cidrs" {
#   type    = list(string)
#   default = []
# }

# variable "allow_app_ports" {
#   type    = list(number)
#   default = []
# }

variable "tags" {
  type    = map(string)
  default = {}
}
variable "user_data" {
  type    = string
  default = null
}


