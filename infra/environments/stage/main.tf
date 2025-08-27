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
  tags         = var.tags
}

module "nlb" {
  source = "../../platform/container/nlb"


  region     = var.region
  name       = "stage-idlms-nlb"
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids # use private_subnet_ids if internal = true
  internal   = false                            # true for internal NLB


  listener_port     = 80
  listener_protocol = "TCP"


  target_port     = 8080 # your EC2 app port
  target_protocol = "TCP"
  target_type     = "instance" # or "ip"


  target_instance_ids = [module.compute.ec2_instance_id]
  # target_ips = [module.compute.ec2_private_ip] # if target_type = "ip"


  tags = {
    Project     = "IDLMS"
    Environment = var.env_name
  }
}
