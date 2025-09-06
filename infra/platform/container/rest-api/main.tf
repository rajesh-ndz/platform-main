# No provider block here; provider is set by the stack

# Read NLB details from SSM (written by NLB stack)
data "aws_ssm_parameter" "lb_arn"      { name = "${var.nlb_ssm_prefix}/lb_arn" }
data "aws_ssm_parameter" "lb_dns_name" { name = "${var.nlb_ssm_prefix}/lb_dns_name" }

locals {
  nlb_arn          = data.aws_ssm_parameter.lb_arn.value
  nlb_dns_name     = data.aws_ssm_parameter.lb_dns_name.value
  backend_base_url = "http://${local.nlb_dns_name}:${var.port}"
}

# IAM role for API Gateway to push execution logs to CloudWatch
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
  name               = "${var.api_name}-cw-logs-${var.env_name}"
  assume_role_policy = data.aws_iam_policy_document.apigw_logs_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "apigw_logs" {
  role       = aws_iam_role.apigw_logs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

# Account-level CloudWatch logs role for API Gateway
resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.apigw_logs.arn
}

# Access log group for the stage
resource "aws_cloudwatch_log_group" "access" {
  name              = "/aws/apigateway/${var.api_name}-${var.env_name}"
  retention_in_days = var.access_log_retention_days
  tags              = var.tags
}

# VPC Link to the internal NLB
resource "aws_api_gateway_vpc_link" "this" {
  name        = "${var.api_name}-vpc-link-${var.env_name}"
  target_arns = [local.nlb_arn]
  tags        = var.tags
}

# The REST API itself
resource "aws_api_gateway_rest_api" "this" {
  name        = "${var.api_name}-${var.env_name}"
  description = var.description
  endpoint_configuration { types = [var.endpoint_type] }
  tags = var.tags
}

# Root ANY -> NLB
resource "aws_api_gateway_method" "root_any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_rest_api.this.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_any" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_rest_api.this.root_resource_id
  http_method             = aws_api_gateway_method.root_any.http_method
  type                    = "HTTP_PROXY"
  uri                     = local.backend_base_url
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.this.id
  integration_http_method = "ANY"
}

# /{proxy+} ANY -> NLB/{proxy}
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_any" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_any.http_method
  type                    = "HTTP_PROXY"
  uri                     = "${local.backend_base_url}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.this.id
  integration_http_method = "ANY"
}

# Deployment + Stage with access logs
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    redeploy_hash = sha1(jsonencode([
      aws_api_gateway_integration.root_any.id,
      aws_api_gateway_integration.proxy_any.id
    ]))
  }
  lifecycle { create_before_destroy = true }
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = var.stage_name

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access.arn
    format = jsonencode({
      requestId      = "$context.requestId",
      ip             = "$context.identity.sourceIp",
      requestTime    = "$context.requestTime",
      httpMethod     = "$context.httpMethod",
      resourcePath   = "$context.resourcePath",
      status         = "$context.status",
      protocol       = "$context.protocol",
      responseLength = "$context.responseLength"
    })
  }

  tags = var.tags
}

# Execution logs / metrics per method
resource "aws_api_gateway_method_settings" "all" {
  count       = var.enable_execution_logs ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled    = var.execution_metrics_enabled
    logging_level      = var.execution_log_level   # OFF | ERROR | INFO
    data_trace_enabled = var.execution_data_trace
  }
}

locals {
  invoke_url = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.this.stage_name}"
}

# Keep outputs ONLY here (avoid duplicates)
output "rest_api_id"      { value = aws_api_gateway_rest_api.this.id }
output "vpc_link_id"      { value = aws_api_gateway_vpc_link.this.id }
output "access_log_group" { value = aws_cloudwatch_log_group.access.name }
output "stage_name"       { value = aws_api_gateway_stage.this.stage_name }
output "invoke_url"       { value = local.invoke_url }
