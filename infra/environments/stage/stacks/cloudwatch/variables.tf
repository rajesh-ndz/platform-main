variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "nlb_ssm_prefix" {
  type = string
}

variable "rest_state_bucket" {
  type    = string
  default = "idlms-terraform-state-backend"
}

variable "rest_state_region" {
  type    = string
  default = "ap-south-1"
}

variable "rest_state_key" {
  type    = string
  default = "stage/rest-api/terraform.tfstate"
}

variable "port" {
  type    = number
  default = 4000
}

variable "alarm_actions" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
