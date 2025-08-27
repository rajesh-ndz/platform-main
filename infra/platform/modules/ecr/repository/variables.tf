variable "repository_names" {
  description = "Full ECR repository names (e.g., stage-idlms-api). Use lowercase letters, numbers, hyphens, slashes."
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "MUTABLE or IMMUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Enable ECR image scanning on push"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Force delete repositories with images on destroy"
  type        = bool
  default     = true
}

variable "keep_last_images" {
  description = "How many recent images to retain (by any tag)"
  type        = number
  default     = 10
}

variable "keep_untagged" {
  description = "Retain some untagged images (0 = expire all untagged)"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
