variable "env_name" { type = string }
variable "region" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }

variable "ec2_name" { type = string }
variable "ami_id" {
  type    = string
  default = ""
} # allow auto AL2023
variable "instance_type" {
  type = string
}
variable "key_name" {
  type    = string
  default = null
}

variable "allow_ssh_cidrs" {
  description = "CIDRs allowed to SSH (22). Leave empty to disable SSH."
  type        = list(string)
  default     = []
}

variable "allow_app_ports" {
  description = "App TCP ports to open to 0.0.0.0/0 (you can tighten later)"
  type        = list(number)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "user_data" {
  type    = string
  default = null
}
