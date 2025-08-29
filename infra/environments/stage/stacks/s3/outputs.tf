output "bucket_name" {
  value       = module.s3.bucket_name
  description = "S3 bucket name"
}

output "bucket_arn" {
  value       = module.s3.bucket_arn
  description = "S3 bucket ARN"
}

output "bucket_domain_name" {
  value       = module.s3.bucket_domain_name
  description = "Global S3 virtual-hosted-style domain"
}

output "bucket_regional_domain" {
  value       = module.s3.bucket_regional_domain
  description = "Regional S3 domain"
}

output "ssm_bucket_name_param" {
  value       = module.s3.ssm_bucket_name_param
  description = "SSM parameter path for bucket name (or null)"
}

output "ssm_bucket_arn_param" {
  value       = module.s3.ssm_bucket_arn_param
  description = "SSM parameter path for bucket ARN (or null)"
}
