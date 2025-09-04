provider "aws" {
  region = var.region
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = var.network_state_key
    region = var.remote_state_region
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = var.compute_state_key
    region = var.remote_state_region
  }
}

locals {
  effective_instance_ids = var.target_type == "instance" ? (length(var.target_instance_ids) > 0 ? var.target_instance_ids : [data.terraform_remote_state.compute.outputs.instance_id]) : []

  effective_ip_addresses = var.target_type == "ip" ? (length(var.target_ip_addresses) > 0 ? var.target_ip_addresses : [data.terraform_remote_state.compute.outputs.instance_private_ip]) : []
}

module "nlb" {
  source = "../../../../platform/core/nlb"

  env_name   = var.env_name
  tags       = var.tags
  internal   = var.internal
  cross_zone = var.cross_zone

  vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  ports      = var.nlb_ports

  target_type         = var.target_type
  target_instance_ids = local.effective_instance_ids
  target_ip_addresses = local.effective_ip_addresses
}
