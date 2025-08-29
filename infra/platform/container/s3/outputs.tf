output "bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "S3 bucket name"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "S3 bucket ARN"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.this.bucket_domain_name
  description = "Global S3 virtual-hosted-style domain"
}

output "bucket_regional_domain" {
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  description = "Regional S3 domain"
}

output "ssm_bucket_name_param" {
  value       = var.create_ssm_params ? aws_ssm_parameter.bucket_name[0].name : null
  description = "SSM parameter path for bucket name (or null)"
}

output "ssm_bucket_arn_param" {
  value       = var.create_ssm_params ? aws_ssm_parameter.bucket_arn[0].name : null
  description = "SSM parameter path for bucket ARN (or null)"
}
