# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 5.0"
#     }
#   }
# }

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.block_public_access ? 1 : 0
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Optional SSM params for reuse
resource "aws_ssm_parameter" "bucket_name" {
  count = var.ssm_param_bucket_name == null ? 0 : 1

  name  = var.ssm_param_bucket_name
  type  = "String"
  value = aws_s3_bucket.this.bucket
}

resource "aws_ssm_parameter" "bucket_arn" {
  count = var.ssm_param_bucket_arn == null ? 0 : 1

  name  = var.ssm_param_bucket_arn
  type  = "String"
  value = aws_s3_bucket.this.arn
}
