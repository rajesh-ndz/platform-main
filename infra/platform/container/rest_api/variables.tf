variable "region" {
  type        = string
  description = "IMPORTANT: use ap-southeast-1 to match your IAM"
}

variable "environment" {
  type        = string
  description = "\"stage\" | \"prod\""
}

variable "name" {
  type        = string
  description = "e.g. idlms-api"
}

# Where to proxy to (your NLB public DNS)
variable "integration_host" {
  type        = string
  description = "e.g. module.nlb.lb_dns_name"
}

variable "integration_port" {
  type    = number
  default = 80
}

variable "integration_base_path" {
  type        = string
  default     = ""
  description = "Optional base path; no leading slash"
}

variable "use_https" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
