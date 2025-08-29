# terraform {
#   required_version = ">= 1.5.0"
#   required_providers {
#     aws = { source = "hashicorp/aws", version = ">= 5.0" }
#   }
# }

# provider "aws" {
#   region = var.region
# }

locals {
  base_tags = merge(var.tags, { Environment = var.env_name })
}

module "sg_app" {
  source = "../../modules/sg/basic"
  name   = "${var.env_name}-ec2-sg"
  vpc_id = var.vpc_id
  tags   = local.base_tags

  ingress_rules = concat(
    [for cidr in var.allow_ssh_cidrs : {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [cidr]
    }],
    [for p in var.allow_app_ports : {
      from_port   = p
      to_port     = p
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }]
  )
}

module "iam" {
  source = "../../modules/iam/ssm_instance"
  name   = "${var.env_name}-ec2-ssm"
  tags   = local.base_tags
}

module "ec2" {
  source               = "../../modules/ec2/instance"
  name                 = var.ec2_name
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = element(var.private_subnet_ids, 0)
  security_group_ids   = [module.sg_app.security_group_id]
  iam_instance_profile = module.iam.instance_profile_name
  key_name             = var.key_name
  user_data            = var.user_data
  tags                 = local.base_tags
}
