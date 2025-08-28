# -------- Environment basics --------
variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

# -------- Network inputs --------
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
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "instance_tenancy" {
  type    = string
  default = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "instance_tenancy must be 'default' or 'dedicated'."
  }
}

variable "nat_gateway_mode" {
  type    = string
  default = "one_per_az"

  validation {
    condition     = contains(["single", "one_per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be 'single' or 'one_per_az'."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}

# -------- Compute defaults --------
variable "ami_id" {
  description = "If empty, latest AL2023 would be used by compute module; here we pin explicitly."
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
  description = "Optional cloud-init / shell script"
  type        = string
  default     = null
}

# -------- ECR (container repos) --------
variable "ecr_repositories" {
  description = "Short repo names to create (e.g., [\"idlms-api\"])."
  type        = list(string)
  default     = []
}

# Optional: SSM path prefix you used earlier (to silence tfvars warnings)
variable "ssm_path_prefix" {
  type    = string
  default = null
}

# -------- (Optional) S3 lifecycle knobs referenced in tfvars --------
variable "enable_ia_transition" {
  type    = bool
  default = false
}

variable "ia_after_days" {
  type    = number
  default = 30
}

variable "glacier_after_days" {
  type    = number
  default = 90
}

variable "expire_after_days" {
  type    = number
  default = null
}
