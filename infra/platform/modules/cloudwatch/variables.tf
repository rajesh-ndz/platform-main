variable "environment" {
  type = string
}

# Optional: prefix used in alarm names. If null, main.tf can fallback to "idlms-${var.environment}"
variable "prefix" {
  type    = string
  default = null
}

# EC2 alarms
variable "ec2_instance_ids" {
  type    = list(string)
  default = []
}

# Toggle NLB alarms on/off (plan-safe)
variable "enable_nlb_alarms" {
  type    = bool
  default = false
}

# NLB alarms – provide ARN suffix values when enable_nlb_alarms = true
variable "nlb_lb_arn_suffix" {
  type    = string
  default = ""
}

variable "nlb_tg_arn_suffix" {
  type    = string
  default = ""
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
