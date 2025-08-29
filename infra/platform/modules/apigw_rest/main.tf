
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
data "aws_region" "current" {}

locals {
  stage_name = coalesce(var.stage_name, var.environment)
}

resource "aws_api_gateway_rest_api" "this" {
  name = "${var.environment}-${var.name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(
    { Environment = var.environment, Name = "${var.environment}-${var.name}" },
    var.tags
  )
}

# /{proxy+}
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

# Methods (ANY) for root and proxy
resource "aws_api_gateway_method" "root_any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_rest_api.this.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integrations: HTTP proxy to NLB public DNS
resource "aws_api_gateway_integration" "root_any" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_rest_api.this.root_resource_id
  http_method             = aws_api_gateway_method.root_any.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = chomp(var.integration_endpoint)
}

resource "aws_api_gateway_integration" "proxy_any" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_any.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "${chomp(var.integration_endpoint)}/{proxy}"
}

# Deployment (auto-redeploy on URI changes)
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeploy = sha1(jsonencode({
      root_uri = aws_api_gateway_integration.root_any.uri
      prxy_uri = aws_api_gateway_integration.proxy_any.uri
    }))
  }

  lifecycle {
    create_before_destroy = true
  }


}
