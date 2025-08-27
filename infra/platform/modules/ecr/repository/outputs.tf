output "repository_urls" {
  description = "Map repo_name => URL"
  value       = { for k, r in aws_ecr_repository.this : k => r.repository_url }
}

output "repository_arns" {
  description = "Map repo_name => ARN"
  value       = { for k, r in aws_ecr_repository.this : k => r.arn }
}

output "repository_names" {
  description = "List of repository names created"
  value       = [for r in aws_ecr_repository.this : r.name]
}
