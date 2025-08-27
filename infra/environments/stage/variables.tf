variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "instance_tenancy" {
  type = string
}

variable "nat_gateway_mode" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# --- Compute variables ---
variable "ami_id" {
  description = "If empty, latest Amazon Linux 2023 is used"
  type        = string
  default     = "ami-02d26659fd82cf299"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = null
}

variable "allow_ssh_cidrs" {
  type    = list(string)
  default = []
}

variable "allow_app_ports" {
  type    = list(number)
  default = []
}

variable "user_data" {
  type    = string
  default = null
}
