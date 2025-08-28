variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "ec2_instance_ids" {
  type    = list(string)
  default = []
}

variable "nlb_lb_arn_suffix" {
  type    = string
  default = null
}

variable "nlb_tg_arn_suffix" {
  type    = string
  default = null
}

variable "alarm_actions" {
  type    = list(string)
  default = []
}

variable "ok_actions" {
  type    = list(string)
  default = []
}

variable "insufficient_data_actions" {
  type    = list(string)
  default = []
}

variable "create_app_log_group" {
  type    = bool
  default = false
}

variable "app_log_group_name" {
  type    = string
  default = null
}

variable "retention_days" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
