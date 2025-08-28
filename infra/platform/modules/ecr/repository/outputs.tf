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

output "lb_arn_suffix" { value = aws_lb.this.arn_suffix }
output "tg_arn_suffix" { value = aws_lb_target_group.this.arn_suffix }


