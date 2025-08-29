# No provider block here — keep provider in the stack

locals {
  base_tags = merge(var.tags, { Environment = var.env_name })
}

# 1) Security Group (your module expects sg_name + common_tags + ingress_ports)
module "sg_app" {
  source        = "../../modules/sg"
  vpc_id        = var.vpc_id
  sg_name       = "${var.env_name}-app-sg"
  common_tags   = local.base_tags
  ingress_ports = var.app_ports # e.g., [4000]
}

# 2) IAM role/profile for SSM
module "iam_ssm" {
  source = "../../modules/iam/ssm_instance"
  name   = "${var.env_name}-ec2-ssm"
  tags   = local.base_tags
}

# 3) EC2 instance (match your ec2 module var names)
module "ec2" {
  source = "../../modules/ec2"

  name          = var.ec2_name
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.private_subnet_ids, 0)

  security_group_ids    = [module.sg_app.security_group_id]
  instance_profile_name = module.iam_ssm.instance_profile_name

  key_name                    = var.key_name
  associate_public_ip_address = false
  user_data                   = var.user_data

  ec2_tags = local.base_tags

  # REQUIRED by your ec2 module
  cloudwatch_ssm_config_path = var.cloudwatch_ssm_config_path
}
