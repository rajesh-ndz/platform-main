output "repository_arns" {
  value = { for k, r in aws_ecr_repository.this : k => r.arn }
}
output "repository_urls" {
  value = { for k, r in aws_ecr_repository.this : k => r.repository_url }
}
output "repository_names" {
  value = keys(aws_ecr_repository.this)
}
output "ssm_parameter_names" {
  value = try([for p in aws_ssm_parameter.repo_url : p.name], [])
}
