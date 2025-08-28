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

module "ecr" {
  source = "../../platform/container/ecr"

  env_name     = var.env_name
  repositories = var.ecr_repositories
  name         = "idlms-api"
  tags         = var.tags
}

module "nlb" {
  source = "../../platform/container/nlb"

  region     = var.region
  name       = "${var.env_name}-idlms-nlb"
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  internal   = false

  listener_port     = 80
  listener_protocol = "TCP"

  target_port     = 8080 # your app port
  target_protocol = "TCP"
  target_type     = "instance"

  target_instance_ids = [module.compute.instance_id]

  tags = {
    Project     = "IDLMS"
    Environment = var.env_name
  }
}

module "cloudwatch" {
  source = "../../platform/core/cloudwatch"

  region      = var.region
  environment = var.env_name

  # reuse existing compute + nlb outputs
  ec2_instance_ids  = [module.compute.instance_id]
  nlb_lb_arn_suffix = module.nlb.lb_arn_suffix
  nlb_tg_arn_suffix = module.nlb.tg_arn_suffix

  # optional SNS ARNs for alarm notifications (leave empty if none)
  alarm_actions = []
  ok_actions    = []

  # optional app log group (create now, use later with CW Agent)
  create_app_log_group = true
  app_log_group_name   = "/idlms/${var.env_name}/app"
  retention_days       = 30

  tags = {
    Project     = "IDLMS"
    Environment = var.env_name
    Owner       = "Platform"
  }
}

module "rest_api" {
  source = "../../platform/container/rest_api"

  # Your IAM policy allows API Gateway only in ap-southeast-1
  region = "ap-southeast-1"

  environment = var.env_name
  name        = "idlms-api"

  # Reuse the NLB you created in ap-south-1 (public NLB DNS)
  integration_host      = module.nlb.lb_dns_name
  integration_port      = 80
  integration_base_path = ""    # set if your app expects a prefix
  use_https             = false # true only if your NLB listener is TLS

  tags = {
    Project     = "IDLMS"
    Environment = var.env_name
    Owner       = "Platform"
  }
}
