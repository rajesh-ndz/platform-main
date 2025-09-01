variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "stage_name" {
  type = string
}

variable "api_port" {
  type = number
}

variable "api_description" {
  type    = string
  default = "IDLMS Stage API"
}

variable "binary_media_types" {
  type    = list(string)
  default = []
}

variable "log_retention_days" {
  type    = number
  default = 7
}

# Stage logging / throttling
variable "metrics_enabled" {
  type    = bool
  default = true
}

variable "logging_level" {
  type    = string
  default = "INFO" # OFF|ERROR|INFO
}

variable "data_trace_enabled" {
  type    = bool
  default = false
}

variable "throttling_rate_limit" {
  type    = number
  default = 1000
}

variable "throttling_burst_limit" {
  type    = number
  default = 500
}

# Where to read NLB remote state from
variable "nlb_tf_state_bucket" {
  type = string
}

variable "nlb_tf_state_key" {
  type = string
}

variable "nlb_tf_state_region" {
  type = string
}
