# Core
variable "environment" {
  type        = string
  description = "Environment name (e.g., stage, prod)"
}

variable "region" {
  type        = string
  description = "AWS region (e.g., ap-south-1)"
}

# Feature flags
variable "enable_ec2_alarms" {
  type        = bool
  default     = false
  description = "Enable CloudWatch alarms for EC2 instances"
}

variable "enable_nlb_alarms" {
  type        = bool
  default     = false
  description = "Enable CloudWatch alarms for NLB"
}

# General settings
variable "retention_days" {
  type        = number
  default     = 30
  description = "CloudWatch Logs retention in days"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional common tags"
}

# Optional overrides (useful if you don't want to read from remote state)
variable "ec2_instance_ids" {
  type        = list(string)
  default     = []
  description = "Optional explicit list of EC2 instance IDs for alarms; if empty, use remote state"
}

variable "nlb_arn" {
  type        = string
  default     = null
  description = "Optional full NLB ARN override; if null, derive from remote state (then compute ARN suffix in locals)"
}
