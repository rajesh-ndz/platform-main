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

data "terraform_remote_state" "nlb" {
  backend = "s3"
  config = {
    bucket         = "idlms-terraform-state-backend"
    key            = "stage/nlb/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "idlms-terraform-locks"
    encrypt        = true
  }
}


module "cloudwatch" {
  source            = "../../../../platform/core/cloudwatch"
  environment       = var.environment
  enable_ec2_alarms = var.enable_ec2_alarms
  enable_nlb_alarms = var.enable_nlb_alarms
  ec2_instance_ids  = local.computed_ec2_ids
  nlb_arn           = local.computed_nlb_arn
  retention_days    = var.retention_days
  tags              = var.tags
}
