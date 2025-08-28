output "repository_arns" {
  value = { for k, v in aws_ecr_repository.this : k => v.arn }
}

output "repository_names" {
  value = keys(aws_ecr_repository.this)
}

output "repository_urls" {
  value = { for k, v in aws_ecr_repository.this : k => v.repository_url }
}

output "ssm_parameter_names" {
  value       = try([for p in aws_ssm_parameter.repo_url : p.name], [])
  description = "List of SSM parameter names created (if create_ssm_param=true)"
}

