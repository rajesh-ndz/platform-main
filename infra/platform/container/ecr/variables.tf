variable "env_name" {
  description = "Environment name, e.g. stage, prod"
  type        = string
}

variable "repositories" {
  description = "List of ECR repository names (we'll prefix with env if you want)"
  type        = list(string)
}

variable "prefix_with_env" {
  description = "If true, each repo becomes <env>-<name>"
  type        = bool
  default     = true
}

# Policy knobs (forwarded to module)
variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "force_delete" {
  type    = bool
  default = false
}

variable "encryption_type" {
  type    = string
  default = "AES256"
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "keep_untagged" {
  type    = number
  default = 0
}

variable "keep_last_images" {
  type    = number
  default = 30
}

variable "additional_rules" {
  type = list(object({
    rulePriority = number
    description  = string
    selection = object({
      tagStatus   = string
      countType   = string
      countNumber = number
    })
    action = object({ type = string })
  }))
  default = []
}

# Create SSM params at: /idlms/<env>/ecr/<repo>/repository_url
variable "create_ssm_params" {
  type    = bool
  default = true
}

variable "ssm_path_prefix" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
