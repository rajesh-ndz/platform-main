provider "aws" { region = var.region }

data "aws_ssm_parameter" "lb_arn" { name = "${var.nlb_ssm_prefix}/lb_arn" }
data "aws_ssm_parameter" "lb_dns_name" { name = "${var.nlb_ssm_prefix}/lb_dns_name" }

locals {
  nlb_arn          = data.aws_ssm_parameter.lb_arn.value
  nlb_dns_name     = data.aws_ssm_parameter.lb_dns_name.value
  backend_base_url = "http://${local.nlb_dns_name}:${var.port}"
}

# IAM role for API Gateway execution logs
data "aws_iam_policy_document" "apigw_logs_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "apigw_logs" {
  name               = "idlms-${var.env_name}-apigw-logs-role"
  assume_role_policy = data.aws_iam_policy_document.apigw_logs_assume.json
  tags               = merge(var.tags, { Environment = var.env_name, Project = "IDLMS" })
}

data "aws_iam_policy_document" "apigw_logs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup", "logs:CreateLogStream", "logs:DescribeLogGroups",
      "logs:DescribeLogStreams", "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "apigw_logs" {
  name   = "idlms-${var.env_name}-apigw-logs-policy"
  role   = aws_iam_role.apigw_logs.id
  policy = data.aws_iam_policy_document.apigw_logs.json
}

# Attach logging role to API Gateway account
resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.apigw_logs.arn
}

# VPC Link to internal NLB
resource "aws_api_gateway_vpc_link" "this" {
  name        = "${var.api_name}-vpc-link-${var.env_name}"
  target_arns = [local.nlb_arn]
  tags        = merge(var.tags, { Environment = var.env_name, Project = "IDLMS" })
}

# REST API
resource "aws_api_gateway_rest_api" "this" {
  name        = "${var.api_name}-${var.env_name}"
  description = var.description
  endpoint_configuration { types = [var.endpoint_type] }
  tags = merge(var.tags, { Environment = var.env_name, Project = "IDLMS" })
}

# Resources
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

# Methods
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
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Integrations via VPC Link (HTTP_PROXY)
resource "aws_api_gateway_integration" "root" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  http_method = aws_api_gateway_method.root_any.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.this.id
  uri                     = local.backend_base_url
}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_any.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.this.id
  uri                     = "${local.backend_base_url}/{proxy}"
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Access logs
resource "aws_cloudwatch_log_group" "apigw_access" {
  name              = "/aws/apigw/${var.api_name}/${var.env_name}/access"
  retention_in_days = var.access_log_retention_days
  tags              = merge(var.tags, { Environment = var.env_name, Project = "IDLMS" })
}

# Deployment & Stage
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    redeploy_hash = sha1(jsonencode({
      resources = [
        aws_api_gateway_method.root_any.id,
        aws_api_gateway_method.proxy_any.id,
        aws_api_gateway_integration.root.id,
        aws_api_gateway_integration.proxy.id,
      ]
    }))
  }
  lifecycle { create_before_destroy = true }
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = var.stage_name

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigw_access.arn
    format = jsonencode({
      requestId          = "$context.requestId",
      ip                 = "$context.identity.sourceIp",
      caller             = "$context.identity.caller",
      user               = "$context.identity.user",
      requestTime        = "$context.requestTime",
      httpMethod         = "$context.httpMethod",
      resourcePath       = "$context.resourcePath",
      status             = "$context.status",
      protocol           = "$context.protocol",
      responseLength     = "$context.responseLength",
      integrationStatus  = "$context.integrationStatus",
      integrationLatency = "$context.integrationLatency"
    })
  }

  tags = merge(var.tags, { Environment = var.env_name, Project = "IDLMS" })

  depends_on = [aws_api_gateway_account.this]
}

# Execution logs & metrics at stage level
resource "aws_api_gateway_method_settings" "all" {
  count       = var.enable_execution_logs ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = false
  }
}
