output "rest_api_id"        { value = aws_api_gateway_rest_api.this.id }
output "rest_api_name"      { value = aws_api_gateway_rest_api.this.name }
output "rest_api_execution_arn" { value = aws_api_gateway_rest_api.this.execution_arn }
output "vpc_link_id"        { value = aws_api_gateway_vpc_link.this.id }
output "stage_name"         { value = aws_api_gateway_stage.this.stage_name }
output "access_log_group"   { value = aws_cloudwatch_log_group.apigw_access.name }
output "invoke_url"         { value = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.this.stage_name}" }
