variable "env_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnet_ids" {
  description = "Subnets for the NLB (usually private subnets)"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

variable "ports" {
  description = "Ports to expose on the NLB (TCP listeners/targets)"
  type        = list(number)
  default     = []
}

variable "internal" {
  description = "true = internal NLB, false = internet-facing"
  type        = bool
  default     = true
}

variable "target_type" {
  description = "instance or ip"
  type        = string
  default     = "instance"

  validation {
    condition     = contains(["instance", "ip"], var.target_type)
    error_message = "target_type must be one of: instance, ip."
  }
}

variable "cross_zone" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "target_instance_ids" {
  description = "Used when target_type = instance"
  type        = list(string)
  default     = []
}

variable "target_ip_addresses" {
  description = "Used when target_type = ip"
  type        = list(string)
  default     = []
}

# Optional: create a security group on the NLB itself
variable "create_nlb_sg" {
  type    = bool
  default = false
}

# Optional: which CIDRs may reach the NLB listeners (used only if create_nlb_sg=true)
variable "nlb_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

# Optional: map of listener_port (string) => target_port (number)
# If not provided, target_port == listener_port
variable "port_mappings" {
  type    = map(number)
  default = {}
}
