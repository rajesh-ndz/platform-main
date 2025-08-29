# Read EC2 instance from compute stack (S3 backend)
data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket       = "idlms-terraform-state-backend"
    key          = "stage/compute/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

locals {
  # Your compute stack exposed "instance_id". Wrap in a list for module input.
  ec2_ids = try([data.terraform_remote_state.compute.outputs.instance_id], [])
}

module "cloudwatch" {
  source            = "../../../../platform/core/cloudwatch"
  environment       = var.environment
  enable_ec2_alarms = var.enable_ec2_alarms
  enable_nlb_alarms = var.enable_nlb_alarms # false for now
  ec2_instance_ids  = local.ec2_ids
  retention_days    = var.retention_days
  tags              = var.tags
}
