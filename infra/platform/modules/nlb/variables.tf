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
    error_message = "listener_protocol must be TCP, TLS, UDP, or TCP_UDP"
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
    error_message = "target_protocol must be TCP, TLS, UDP, or TCP_UDP"
  }
}

variable "target_type" {
  description = "Target registration mode: instance or ip"
  type        = string
  default     = "instance"
  validation {
    condition     = contains(["instance", "ip"], var.target_type)
    error_message = "target_type must be 'instance' or 'ip'"
  }
}

variable "target_instance_ids" {
  description = "Instance IDs for target registration when target_type = 'instance'"
  type        = list(string)
  default     = []
}

variable "target_ips" {
  description = "IP addresses for target registration when target_type = 'ip'"
  type        = list(string)
  default     = []
}

variable "health_check_port" {
  type    = string
  default = "traffic-port"
}

variable "health_check_protocol" {
  type    = string
  default = "TCP"
}

variable "deregistration_delay" {
  type    = number
  default = 60
}

variable "cross_zone" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
