variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "enable_ec2_alarms" {
  type    = bool
  default = false
}

variable "enable_nlb_alarms" {
  type    = bool
  default = false
}

variable "retention_days" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}



# Optional list overrides if you don't want to read from remote state
variable "ec2_instance_ids" {
  type    = list(string)
  default = []
}

variable "nlb_arn" {
  type    = string
  default = null
}

