variable "env_name"           { type = string }
variable "region"             { type = string }
variable "ec2_name"           { type = string }
variable "instance_type"      { type = string }
variable "ami_id"             { type = string }
variable "key_name"           { type = string }
variable "app_ports"          { type = list(number) }
variable "cloudwatch_ssm_config_path" { type = string }

# network inputs (from remote_state at the stack)
variable "vpc_id"             { type = string }
variable "private_subnet_ids" { type = list(string) }

# reuse existing IAM instead of creating (optional)
variable "existing_iam_role_name" {
  type    = string
  default = null
}
variable "existing_instance_profile_name" {
  type    = string
  default = null
}

# optional extras
variable "docker_artifact_bucket" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
