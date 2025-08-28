output "nlb_dns_name" {
  value = module.nlb.lb_dns_name
}
output "nlb_arn" {
  value = module.nlb.lb_arn
}
output "nlb_tg_arn" {
  value = module.nlb.tg_arn
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}
output "ecr_repository_names" {

  value = module.ecr.repository_names
}

# REST API (API Gateway) handy outputs
output "rest_api_invoke_url" {
  value       = module.rest_api.invoke_url
  description = "Invoke URL for the deployed REST API stage"
}

output "rest_api_id" {
  value       = module.rest_api.rest_api_id
  description = "API Gateway REST API id"
}

output "rest_api_execution_arn" {
  value       = module.rest_api.execution_arn
  description = "API Gateway execution ARN for IAM permissions"
}
