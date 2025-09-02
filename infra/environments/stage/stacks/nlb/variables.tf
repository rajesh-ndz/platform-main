variable "env_name" { type = string }
variable "region" { type = string }

variable "vpc_cidr" { type = string }
variable "ports" { type = list(number) }
variable "nlb_name" {
  type    = string
  default = "nlb"
}

# Register instances via remote-state OR override here
variable "instance_ids" {
  type    = list(string)
  default = []
}

# Open compute SG from these CIDRs (defaults to vpc_cidr when empty)
variable "source_cidrs_for_compute" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
