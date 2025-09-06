variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "nlb_ssm_prefix" {
  type = string
}

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
  default = "IDLMS REST API via VPC Link to internal NLB"
}

variable "port" {
  type    = number
  default = 4000
}

variable "endpoint_type" {
  type    = string
  default = "REGIONAL"
}

variable "access_log_retention_days" {
  type    = number
  default = 14
}

variable "enable_execution_logs" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
