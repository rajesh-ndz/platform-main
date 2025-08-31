variable "region" {
  type = string # provider file already uses this
}

variable "env_name" {
  type = string
}

variable "repositories" {
  type = list(string) # e.g., ["idlms-api"]
}

variable "image_tag_mutability" {
  type    = string
  default = "IMMUTABLE"
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "force_delete" {
  type    = bool
  default = true
}

variable "prefix_with_env" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
