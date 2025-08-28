variable "environment" {
  type = string
}

# Controls for conditional creation (known at plan time)
variable "enable_ec2_alarms" {
  type    = bool
  default = false
}

variable "enable_nlb_alarms" {
  type    = bool
  default = false
}

# Inputs
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

# Alarm actions (SNS ARNs)
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

# Optional log group
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
