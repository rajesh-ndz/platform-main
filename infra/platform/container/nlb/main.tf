module "nlb" {
  source = "../../modules/nlb"

  env_name   = var.env_name
  name       = var.name
  vpc_id     = var.vpc_id

  subnet_ids     = var.subnet_ids
  subnet_mapping = var.subnet_mapping

  internal         = var.internal

  ports        = var.ports
  target_type  = var.target_type
  instance_ids = var.instance_ids
  ip_addresses = var.ip_addresses

  cross_zone            = var.cross_zone
  deregistration_delay  = var.deregistration_delay
  health_check_protocol = var.health_check_protocol

  tags = var.tags
}
