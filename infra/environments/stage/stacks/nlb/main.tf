# Reuse network (VPC + subnets)
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "idlms-terraform-state-backend"
    key    = "stage/network/terraform.tfstate"
    region = "ap-south-1"
  }
}

# (Optional) Reuse compute to register instance(s) and to open SG from CIDRs
data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket = "idlms-terraform-state-backend"
    key    = "stage/compute/terraform.tfstate"
    region = "ap-south-1"
  }
}

locals {
  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids  = data.terraform_remote_state.network.outputs.private_subnet_ids
  compute_sg_id       = try(data.terraform_remote_state.compute.outputs.security_group_id, null)
  compute_instance_id = try(data.terraform_remote_state.compute.outputs.instance_id, null)

  # Use explicit instance_ids if provided, else fallback to compute.state
  effective_instance_ids = length(var.instance_ids) > 0 ? var.instance_ids : (
    local.compute_instance_id != null ? [local.compute_instance_id] : []
  )

  source_cidrs = length(var.source_cidrs_for_compute) > 0 ? var.source_cidrs_for_compute : [var.vpc_cidr]
}

module "nlb" {
  source = "../../../../platform/container/nlb"

  env_name = var.env_name
  name     = var.nlb_name
  vpc_id   = local.vpc_id

  subnet_ids = local.private_subnet_ids # Internal NLB in private subnets

  internal = true # ← your requirement

  ports        = var.ports # e.g., [4000]
  target_type  = "instance"
  instance_ids = local.effective_instance_ids

  tags = var.tags
}

# Open compute SG from CIDRs on same ports
resource "aws_security_group_rule" "compute_from_cidrs" {
  for_each = local.compute_sg_id != null ? toset(flatten([
    for cidr in local.source_cidrs : [
      for p in var.ports : "${cidr}|${p}"
    ]
  ])) : []

  type              = "ingress"
  security_group_id = local.compute_sg_id

  from_port = tonumber(split("|", each.key)[1])
  to_port   = tonumber(split("|", each.key)[1])
  protocol  = "tcp"

  cidr_blocks = [split("|", each.key)[0]]
  description = "Allow from CIDR to compute for NLB traffic"
}

output "lb_arn" { value = module.nlb.lb_arn }
output "lb_dns_name" { value = module.nlb.lb_dns_name }
output "lb_zone_id" { value = module.nlb.lb_zone_id }
output "target_group_arns" { value = module.nlb.target_group_arns }
output "listener_arns" { value = module.nlb.listener_arns }
