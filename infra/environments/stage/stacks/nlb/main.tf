data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket         = "idlms-terraform-state-backend"
    key            = "stage/network/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "idlms-terraform-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket         = "idlms-terraform-state-backend"
    key            = "stage/compute/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "idlms-terraform-locks"
    encrypt        = true
  }
}


module "nlb" {
  source = "../../../../platform/container/nlb"

  name       = var.name
  vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids
  internal   = var.internal

  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol

  target_port     = var.target_port
  target_protocol = var.target_protocol
  target_type     = var.target_type

  target_instance_ids = local.computed_instance_ids
  target_ips          = var.target_ips

  tags = merge(var.tags, { Environment = var.env_name })
}

output "lb_arn" { value = module.nlb.lb_arn }
output "lb_dns_name" { value = module.nlb.lb_dns_name }
