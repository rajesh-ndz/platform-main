provider "aws" {
  region = var.region
}

locals {
  scheme    = var.use_https ? "https" : "http"
  base_path = trim(var.integration_base_path, "/")
  endpoint  = local.base_path == "" ? "${local.scheme}://${var.integration_host}:${var.integration_port}" : "${local.scheme}://${var.integration_host}:${var.integration_port}/${local.base_path}"
}

module "rest" {
  source = "../../modules/apigw_rest"

  name                 = var.name
  environment          = var.environment
  integration_endpoint = local.endpoint
  stage_name           = var.environment
  tags                 = var.tags
}
