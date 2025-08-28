output "bucket_id" {
  value       = module.bucket.bucket_id
  description = "ID of the S3 bucket"
}

output "bucket_arn" {
  value       = module.bucket.bucket_arn
  description = "ARN of the S3 bucket"
}

output "bucket_domain_name" {
  value       = module.bucket.bucket_domain_name
  description = "Global (legacy) S3 website/domain name"
}

output "bucket_regional_domain" {
  value       = module.bucket.bucket_regional_domain
  description = "Regional S3 bucket domain name"
}

output "ssm_bucket_name_param" {
  value       = module.bucket.ssm_bucket_name_param
  description = "SSM Parameter name storing the bucket name"
}

output "ssm_bucket_arn_param" {
  value       = module.bucket.ssm_bucket_arn_param
  description = "SSM Parameter name storing the bucket ARN"
}
