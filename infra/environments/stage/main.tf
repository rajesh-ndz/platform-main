module "network" {
  source               = "../../platform/core/network"
  env_name             = var.env_name
  region               = var.region
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy
  nat_gateway_mode     = var.nat_gateway_mode
  tags                 = var.tags
}

output "vpc_id" { value = module.network.vpc_id }
output "public_subnet_ids" { value = module.network.public_subnet_ids }
output "private_subnet_ids" { value = module.network.private_subnet_ids }

# --- ECR (container wrapper expects region/environment/name) ---
module "ecr" {
  source       = "../../platform/container/ecr"
  env_name     = var.env_name
  repositories = var.ecr_repositories # e.g. ["idlms-api", "idlms-worker"]

  # optional knobs (defaults are safe)
  # image_tag_mutability = "IMMUTABLE"
  # keep_last_images     = 30
  # create_ssm_params    = true
  # ssm_path_prefix      = "/idlms/${var.env_name}/ecr"

  tags = var.tags
}

# --- NLB ---
module "nlb" {
  source = "../../platform/container/nlb"

  region     = var.region
  name       = "${var.env_name}-idlms-nlb"
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  internal   = false

  listener_port     = 80
  listener_protocol = "TCP"

  target_port     = 8080
  target_protocol = "TCP"
  target_type     = "instance"

  # NOTE: If module.compute.instance_id is unknown at plan time, attachments may need a second apply.
  target_instance_ids = [module.compute.instance_id]

  tags = {
    Project     = "IDLMS"
    Environment = var.env_name
  }
}
module "cloudwatch" {
  source      = "../../platform/core/cloudwatch"
  environment = var.env_name

  enable_ec2_alarms = true
  enable_nlb_alarms = true

  ec2_instance_ids  = [module.compute.instance_id]
  nlb_lb_arn_suffix = module.nlb.lb_arn_suffix
  nlb_tg_arn_suffix = module.nlb.tg_arn_suffix

  alarm_actions = [] # add SNS arns if you have
  ok_actions    = []

  create_app_log_group = true
  app_log_group_name   = "/idlms/${var.env_name}/app"
  retention_days       = 30

  tags = var.tags
}



# --- REST API (regional in ap-southeast-1) ---
module "rest_api" {
  source = "../../platform/container/rest_api"

  region      = "ap-southeast-1"
  environment = var.env_name
  name        = "idlms-api"

  integration_host      = module.nlb.lb_dns_name
  integration_port      = 80
  integration_base_path = ""
  use_https             = false

  tags = {
    Project     = "IDLMS"
    Environment = var.env_name
    Owner       = "Platform"
  }
}
