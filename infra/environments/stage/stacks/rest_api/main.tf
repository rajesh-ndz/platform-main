# --- VPC Link (REST v1) using NLB ARN(s) ---
resource "aws_api_gateway_vpc_link" "this" {
  name        = "${var.environment}-vpc-link"
  target_arns = local.vpc_link_target_arns
  tags        = local.common_tags
}

# --- REST API skeleton ---
resource "aws_api_gateway_rest_api" "this" {
  name               = "${var.environment}-api"
  description        = var.api_description
  binary_media_types = var.binary_media_types
  tags               = local.common_tags
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "root" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_rest_api.this.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# --- Integrations over the VPC Link to NLB DNS ---
resource "aws_api_gateway_integration" "root" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_rest_api.this.root_resource_id
  http_method             = aws_api_gateway_method.root.http_method
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.this.id
  uri                     = "http://${local.nlb_dns_name}:${var.api_port}"
  integration_http_method = "ANY"
  timeout_milliseconds    = 29000
}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.proxy.id
  http_method     = aws_api_gateway_method.proxy.http_method
  type            = "HTTP_PROXY"
  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.this.id
  uri             = "http://${local.nlb_dns_name}:${var.api_port}/{proxy}"
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
  integration_http_method = "ANY"
  timeout_milliseconds    = 29000
}

# --- Logging to CloudWatch ---
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/api-gateway/${var.environment}-api"
  retention_in_days = var.log_retention_days
  tags              = local.common_tags
}

resource "aws_iam_role" "api_gw_cloudwatch" {
  name = "${var.environment}-apigw-cloudwatch-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "apigateway.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "api_gw_logs" {
  role       = aws_iam_role.api_gw_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_account" "account" {
  cloudwatch_role_arn = aws_iam_role.api_gw_cloudwatch.arn
}

# --- Deployment + Stage ---
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    redeploy = sha1(jsonencode({
      i = [
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
  tags          = local.common_tags

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      requestId    = "$context.requestId"
      requestTime  = "$context.requestTime"
      httpMethod   = "$context.httpMethod"
      resourcePath = "$context.resourcePath"
      status       = "$context.status"
      protocol     = "$context.protocol"
      responseLen  = "$context.responseLength"
      ip           = "$context.identity.sourceIp"
      caller       = "$context.identity.caller"
      user         = "$context.identity.user"
    })
  }
}

# Separate method settings resource (provider v6)
resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled        = var.metrics_enabled
    logging_level          = var.logging_level
    data_trace_enabled     = var.data_trace_enabled
    throttling_rate_limit  = var.throttling_rate_limit
    throttling_burst_limit = var.throttling_burst_limit
  }
}
