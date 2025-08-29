# --- Remote state: read Network + Compute from S3 backend ---
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket       = "idlms-terraform-state-backend"
    key          = "stage/network/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket       = "idlms-terraform-state-backend"
    key          = "stage/compute/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

# --- NLB wrapper module ---
module "nlb" {
  source = "../../../../platform/container/nlb"

  name       = var.name
  vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids
  internal   = var.internal

  # Listener
  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol

  # Target group
  target_port     = var.target_port
  target_protocol = var.target_protocol
  target_type     = var.target_type

  # Attach the EC2 instance from the compute stack (when target_type = "instance")
  target_instance_ids = [data.terraform_remote_state.compute.outputs.instance_id]

  # Tags
  tags = merge(var.tags, { Environment = var.env_name })
}

# --- Outputs ---
output "lb_arn" {
  value = module.nlb.lb_arn
}

output "lb_dns_name" {
  value = module.nlb.lb_dns_name
}
