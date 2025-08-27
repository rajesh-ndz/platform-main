provider "aws" { region = var.region }


module "nlb" {
  source = "../../modules/nlb"


  name       = var.name
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  internal   = var.internal


  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol


  target_port     = var.target_port
  target_protocol = var.target_protocol
  target_type     = var.target_type


  target_instance_ids = var.target_instance_ids
  target_ips          = var.target_ips


  tags = var.tags
}
