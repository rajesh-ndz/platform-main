variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

# API basics
variable "api_name" {
  type    = string
  default = "idlms-api"
}

variable "stage_name" {
  type    = string
  default = "stage"
}

variable "description" {
  type    = string
  default = "IDLMS REST API via VPC Link -> NLB"
}

# NLB from SSM and backend port
variable "nlb_ssm_prefix" {
  type = string # e.g., "/idlms/nlb/stage"
}

variable "port" {
  type    = number
  default = 4000
}

# Endpoint type: EDGE | REGIONAL | PRIVATE
variable "endpoint_type" {
  type    = string
  default = "REGIONAL"
}

# Logging
variable "access_log_retention_days" {
  type    = number
  default = 14
}

variable "enable_execution_logs" {
  type    = bool
  default = true
}

# Tags
variable "tags" {
  type    = map(string)
  default = {}
}
