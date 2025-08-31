variable "env_name" { type = string }  # e.g., "stage"
variable "region"   { type = string }

# Logical bucket name segment used in SSM path: /idlms/<env>/s3/<s3_name>/...
variable "s3_name"   { type = string  default = "built-artifact" }

# Naming: default to globally-unique 'idlms-<env>-<s3_name>-<account_id>'.
variable "use_idlms_artifact_convention" { type = bool   default = true }
variable "bucket_name_override"          { type = string  default = null }  # wins if set

# Encryption & behavior
variable "sse_algorithm"   { type = string default = "AES256" }
variable "kms_key_id"      { type = string default = null }

variable "versioning"      { type = bool   default = true }
variable "force_destroy"   { type = bool   default = true }

# Lifecycle
variable "enable_ia_transition"   { type = bool   default = false }
variable "ia_after_days"          { type = number default = 30 }
variable "noncurrent_expire_days" { type = number default = 90 }
variable "expire_after_days"      { type = number default = 0 }

# SSM
variable "create_ssm_params" { type = bool   default = true }
variable "ssm_path_prefix"   { type = string default = "/idlms" }

variable "tags"              { type = map(string) default = {} }
