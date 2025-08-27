module "compute" {
  source             = "../../platform/core/compute"
  env_name           = var.env_name
  region             = var.region
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

  ec2_name      = "${var.env_name}-app-1"
  ami_id        = var.ami_id # leave "" to auto-pick AL2023
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = file("${path.module}/user_data_ssm.sh")


  allow_ssh_cidrs = var.allow_ssh_cidrs
  allow_app_ports = var.allow_app_ports
  tags            = var.tags
}

output "ec2_instance_id" {
  value = module.compute.instance_id
}

output "ec2_private_ip" {
  value = module.compute.instance_private_ip
}

output "ec2_sg_id" {
  value = module.compute.security_group_id
}
