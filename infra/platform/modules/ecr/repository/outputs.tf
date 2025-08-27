output "repository_names" {
  description = "Map of repo key to repository name"
  value       = { for k, r in aws_ecr_repository.this : k => r.name }
}

output "repository_urls" {
  description = "Map of repo key to repository URL"
  value       = { for k, r in aws_ecr_repository.this : k => r.repository_url }
}

output "repository_arns" {
  description = "Map of repo key to repository ARN"
  value       = { for k, r in aws_ecr_repository.this : k => r.arn }
}
