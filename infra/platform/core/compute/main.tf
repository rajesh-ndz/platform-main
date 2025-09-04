terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

provider "aws" {
  region = var.region
}

module "sg_app" {
  source            = "../../modules/sg"
  vpc_id            = var.vpc_id
  app_ports         = var.app_ports
  security_group_id = null
  tags              = merge(var.tags, { Name = "${var.env_name}-app-sg" })
}

module "iam_ssm" {
  source                           = "../../modules/iam/ssm_instance"
  name                             = "${var.env_name}-ec2-ssm"
  tags                             = var.tags
  existing_role_name               = var.existing_iam_role_name
  existing_instance_profile_name   = var.existing_instance_profile_name
}

module "ec2" {
  source                 = "../../modules/ec2"
  name                   = var.ec2_name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [ module.sg_app.security_group_id ]
  iam_instance_profile   = module.iam_ssm.instance_profile_name
  key_name               = var.key_name
  region                 = var.region
  cloudwatch_ssm_config_path = var.cloudwatch_ssm_config_path
  docker_artifact_bucket = var.docker_artifact_bucket
  tags                   = merge(var.tags, { Environment = var.env_name, Name = var.ec2_name })
}
