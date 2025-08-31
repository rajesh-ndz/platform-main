variable "env_name" {
  type = string
}

variable "name" {
  type    = string
  default = "nlb"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "subnet_mapping" {
  type = list(object({
    subnet_id            = string
    allocation_id        = optional(string)
    private_ipv4_address = optional(string)
    ipv6_address         = optional(string)
  }))
  default = []
}

variable "internal" {
  type    = bool
  default = true
}

variable "ports" {
  type    = list(number)
  default = [4000]
}

variable "target_type" {
  type    = string
  default = "instance"
}

variable "instance_ids" {
  type    = list(string)
  default = []
}

variable "ip_addresses" {
  type    = list(string)
  default = []
}

variable "cross_zone" {
  type    = bool
  default = true
}

variable "deregistration_delay" {
  type    = number
  default = 60
}

variable "health_check_protocol" {
  type    = string
  default = "TCP"
}

variable "tags" {
  type    = map(string)
  default = {}
}
