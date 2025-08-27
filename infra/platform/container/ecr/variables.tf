variable "env_name" {
  description = "Environment name (e.g., stage, prod)"
  type        = string
}

variable "repositories" {
  description = "Short names you want (e.g., [\"api\", \"web\"])"
  type        = list(string)
}

variable "tags" {
  description = "Common tags (expects Project, Environment, Owner, etc)"
  type        = map(string)
  default     = {}
}
variable "name" {
  type = string
} # e.g., "idlms-api"
