variable "name" { type = string }

variable "ami_id" {
  description = "If null/empty, latest AL2023 will be used"
  type        = string
  default     = ""
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" { type = string }

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "key_name" {
  type    = string
  default = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
