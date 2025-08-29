variable "repository_names" {
  description = "List of repository names to create (strings without env prefix). Caller can prepend env if desired."
  type        = list(string)
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE"
  }
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
  default = "AES256" # or "KMS"
  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be AES256 or KMS"
  }
}

variable "kms_key_id" {
  type    = string
  default = null
}

# Lifecycle policy knobs
variable "keep_untagged" {
  type    = number
  default = 0
} # 0 to disable
variable "keep_last_images" {
  type    = number
  default = 30
} # keep latest N, expire older
variable "additional_rules" {
  description = "Optional extra lifecycle policy rule objects"
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

# Optional SSM params (one param per repo) -> <ssm_path_prefix>/<repo>/repository_url
variable "create_ssm_params" {
  type    = bool
  default = false
}

variable "ssm_path_prefix" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
