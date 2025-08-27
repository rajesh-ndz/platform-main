variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
}

variable "image_tag_mutability" {
  type    = string
  default = "IMMUTABLE" # or "MUTABLE"
  validation {
    condition     = contains(["IMMUTABLE", "MUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be IMMUTABLE or MUTABLE"
  }
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "force_delete" {
  description = "Allow repository deletion even if images exist (safer false in prod)"
  type        = bool
  default     = false
}

variable "encryption_type" {
  description = "AES256 or KMS"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be AES256 or KMS"
  }
}

variable "kms_key_id" {
  description = "KMS key ID/ARN if encryption_type = KMS"
  type        = string
  default     = null
}

variable "keep_untagged" {
  description = "If >0, expire untagged images beyond this count"
  type        = number
  default     = 0
}

variable "keep_last_images" {
  description = "Keep the last N images (older will expire). Must be >= 1."
  type        = number
  default     = 30
  validation {
    condition     = var.keep_last_images >= 1
    error_message = "keep_last_images must be >= 1"
  }
}

variable "additional_rules" {
  description = "Optional extra lifecycle rules (raw JSON-serializable objects)"
  type        = list(any)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
