# Wrapper inputs for the NLB module.
# NOTE: Do NOT include "region" here; inherit it from the root provider.

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "internal" {
  type    = bool
  default = false
}

variable "listener_port" {
  type    = number
  default = 80
}

variable "listener_protocol" {
  type    = string
  default = "TCP"
  validation {
    condition     = contains(["TCP", "TLS", "UDP", "TCP_UDP"], var.listener_protocol)
    error_message = "listener_protocol must be one of: TCP, TLS, UDP, TCP_UDP."
  }
}

variable "target_port" {
  type = number
}

variable "target_protocol" {
  type    = string
  default = "TCP"
  validation {
    condition     = contains(["TCP", "TLS", "UDP", "TCP_UDP"], var.target_protocol)
    error_message = "target_protocol must be one of: TCP, TLS, UDP, TCP_UDP."
  }
}

variable "target_type" {
  type        = string
  default     = "instance"
  description = "Target registration mode"
  validation {
    condition     = contains(["instance", "ip"], var.target_type)
    error_message = "target_type must be 'instance' or 'ip'."
  }
}

variable "target_instance_ids" {
  type        = list(string)
  default     = []
  description = "Used when target_type = 'instance'"
}

variable "target_ips" {
  type        = list(string)
  default     = []
  description = "Used when target_type = 'ip'"
}

variable "tags" {
  type    = map(string)
  default = {}
}
