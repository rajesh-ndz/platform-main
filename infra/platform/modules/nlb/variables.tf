variable "name" {
  type        = string
  description = "Name of the load balancer (and base for TG names)"
}

variable "vpc_id" {
  type        = string
  description = "VPC where target groups live"
}

# Must be 'network' because we use TCP listeners
variable "load_balancer_type" {
  type        = string
  default     = "network"
  description = "LB type. Must be 'network' for TCP."
  validation {
    condition     = var.load_balancer_type == "network"
    error_message = "This module is TCP-based; set load_balancer_type = \"network\"."
  }
}

variable "internal" {
  type        = bool
  default     = false
  description = "Internal NLB (true) or internet-facing (false)"
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  default     = true
  description = "Cross-zone LB for NLB"
}

variable "enable_deletion_protection" {
  type        = bool
  default     = false
  description = "Protect NLB from deletion"
}

# Example element:
# {
#   subnet_id            = "subnet-abc..."
#   allocation_id        = "eipalloc-123..."   # optional (EIP per subnet)
#   private_ipv4_address = "10.0.0.10"        # optional (static NLB IP)
#   ipv6_address         = null               # optional
# }
variable "subnet_mapping" {
  type = list(object({
    subnet_id            = string
    allocation_id        = optional(string)
    private_ipv4_address = optional(string)
    ipv6_address         = optional(string)
  }))
  description = "One mapping per public subnet"
}

# Ports to expose on the NLB (each gets its own TG + listener)
variable "additional_ports" {
  type        = list(number)
  description = "List of TCP listener/target-group ports (e.g., [80, 8080])"
}

# IP targets to register on every port (use instance private IPs or ENI IPs)
variable "target_ips" {
  type        = list(string)
  description = "IP addresses to register into each port's target group"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to NLB & target groups"
}

# Health check knobs (TCP-only by default)
variable "hc_healthy_threshold" {
  type    = number
  default = 2
}

variable "hc_unhealthy_threshold" {
  type    = number
  default = 2
}

variable "hc_timeout" {
  type    = number
  default = 10
}

variable "hc_interval" {
  type    = number
  default = 30
}
