variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

# Remote state: where to read NETWORK (for vpc_id, private_subnet_ids)
variable "tf_state_bucket" {
  type = string
}

variable "network_state_key" {
  type = string
}

# Remote state: where to read COMPUTE (for instance_id / private_ip)
variable "compute_state_key" {
  type = string
}

variable "remote_state_region" {
  type = string
}

# Ports to expose on the NLB
variable "nlb_ports" {
  type    = list(number)
  default = []
}

# instance or ip
variable "target_type" {
  type    = string
  default = "instance"

  validation {
    condition     = contains(["instance", "ip"], var.target_type)
    error_message = "target_type must be one of: instance, ip."
  }
}

# Optional overrides
variable "target_instance_ids" {
  type    = list(string)
  default = []
}

variable "target_ip_addresses" {
  type    = list(string)
  default = []
}

variable "internal" {
  type    = bool
  default = true
}

variable "cross_zone" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
