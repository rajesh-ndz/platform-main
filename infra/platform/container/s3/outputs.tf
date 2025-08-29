output "bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "S3 bucket name"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "S3 bucket ARN"
}

# Convenience domains
output "bucket_domain_name" {
  value       = "${aws_s3_bucket.this.bucket}.s3.amazonaws.com"
  description = "Global S3 virtual-hosted-style domain"
}

output "bucket_regional_domain" {
  value       = "${aws_s3_bucket.this.bucket}.s3.${data.aws_region.current.name}.amazonaws.com"
  description = "Regional S3 domain"
}

# SSM parameter names (null if not created)
output "ssm_bucket_name_param" {
  value       = var.create_ssm_params ? aws_ssm_parameter.bucket_name[0].name : null
  description = "SSM parameter path for bucket name"
}

output "ssm_bucket_arn_param" {
  value       = var.create_ssm_params ? aws_ssm_parameter.bucket_arn[0].name : null
  description = "SSM parameter path for bucket ARN"
}
