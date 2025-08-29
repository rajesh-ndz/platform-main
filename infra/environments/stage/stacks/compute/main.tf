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


module "compute" {
  source             = "../../../../platform/core/compute"
  env_name           = var.env_name
  region             = var.region
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  ec2_name           = var.ec2_name
  instance_type      = var.instance_type
  ami_id             = var.ami_id
  key_name           = var.key_name
  # allow_cidrs        = var.allow_cidrs
  # allow_app_ports    = var.allow_app_ports
  tags      = var.tags
  user_data = var.user_data
}

output "instance_id" {
  value = module.compute.instance_id
}
output "sg_id" {
  value = module.compute.security_group_id
}
