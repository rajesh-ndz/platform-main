module "compute" {
  source             = "../../../../platform/core/compute"
  env_name           = var.env_name
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  ec2_name           = var.ec2_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  app_ports          = var.app_ports
  tags               = var.tags

  cloudwatch_ssm_config_path = var.cloudwatch_ssm_config_path # ← here

}


output "instance_id" {
  value = module.compute.instance_id
}
output "security_group_id" {
  value = module.compute.security_group_id
}
output "instance_private_ip" {
  value = module.compute.instance_private_ip
}
