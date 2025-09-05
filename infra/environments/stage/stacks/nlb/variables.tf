variable "ports" {
  type = list(number)
}

variable "target_instance_ids" {
  type    = list(string)
  default = []
}

variable "ssm_prefix" {
  type        = string
  default     = ""
  description = "Write NLB details to this SSM path if non-empty"
}
