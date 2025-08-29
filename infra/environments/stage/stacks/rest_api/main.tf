data "terraform_remote_state" "nlb" {
  backend = "s3"
  config = {
    bucket       = "idlms-terraform-state-backend"
    key          = "stage/nlb/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

module "rest_api" {
  source = "../../../../platform/container/rest_api"

  name        = var.name
  environment = var.env_name

  integration_host      = data.terraform_remote_state.nlb.outputs.lb_dns_name
  integration_port      = 80
  integration_base_path = var.integration_base_path
  use_https             = var.use_https
  tags                  = var.tags
}

output "api_endpoint" {
  value = module.rest_api.invoke_url
}
