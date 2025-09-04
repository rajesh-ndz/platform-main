variable "env_name" { type = string }
variable "region" { type = string }

# network remote state
variable "tf_state_bucket" { type = string }
variable "network_state_key" { type = string }
variable "remote_state_region" {
  type    = string
  default = null
}

# compute settings
variable "ec2_name" { type = string }
variable "instance_type" { type = string }
variable "app_ports" { type = list(number) }
variable "key_name" { type = string }
variable "ami_id" { type = string }
variable "cloudwatch_ssm_config_path" { type = string }
variable "docker_artifact_bucket" { type = string }

# reuse existing IAM names
variable "ec2_ssm_role_name" { type = string }
variable "ec2_ssm_profile_name" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
