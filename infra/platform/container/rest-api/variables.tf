variable "env_name" { type = string }
variable "region"   { type = string }

variable "api_name"   { type = string }
variable "stage_name" { type = string }
variable "description"{ type = string }

variable "nlb_ssm_prefix" { type = string }
variable "port"           { type = number }
variable "endpoint_type"  { type = string }

variable "access_log_retention_days" { type = number }

variable "enable_execution_logs" { type = bool }

# NEW: execution log controls
variable "execution_log_level" {
  type    = string
  default = "ERROR" # can be "OFF" | "ERROR" | "INFO"
}

variable "execution_metrics_enabled" {
  type    = bool
  default = true
}

variable "execution_data_trace" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
