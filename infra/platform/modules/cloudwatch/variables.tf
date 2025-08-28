variable "environment" {
  type = string
}

# EC2 alarms
variable "ec2_instance_ids" {
  type    = list(string)
  default = []
}

# NLB alarms – use ARN suffix values
variable "nlb_lb_arn_suffix" {
  type    = string
  default = null
}

variable "nlb_tg_arn_suffix" {
  type    = string
  default = null
}

# Alarm actions (SNS ARNs). Leave empty to create alarms with no actions.
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

# Optional log group for future app logs (CloudWatch Agent, etc.)
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
