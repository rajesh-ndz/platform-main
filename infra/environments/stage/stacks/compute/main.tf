terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

# Read NETWORK outputs from existing state (S3)
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = var.network_state_key
    region = coalesce(var.remote_state_region, var.region)
  }
}

module "compute" {
  source = "../../../../platform/core/compute"

  env_name = var.env_name
  region   = var.region

  # pass VPC/subnets from remote state (must be same region as 'region')
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  # instance config
  ec2_name      = var.ec2_name
  instance_type = var.instance_type
  ami_id        = var.ami_id
  key_name      = var.key_name
  app_ports     = var.app_ports

  cloudwatch_ssm_config_path = var.cloudwatch_ssm_config_path
  docker_artifact_bucket     = var.docker_artifact_bucket

  # reuse existing IAM
  existing_iam_role_name         = var.ec2_ssm_role_name
  existing_instance_profile_name = var.ec2_ssm_profile_name

  tags = var.tags
}

# convenience outputs (optional)
output "security_group_id" { value = module.compute.security_group_id }
output "instance_profile_name" { value = module.compute.instance_profile_name }
output "iam_role_name" { value = module.compute.iam_role_name }
