data "aws_caller_identity" "current" {}

locals {
  bucket_name  = var.bucket_name_override != "" ? var.bucket_name_override : "idlms-${var.env_name}-website-built-artifact-${data.aws_caller_identity.current.account_id}"
  default_tags = merge({ Environment = var.env_name, ManagedBy = "terraform", Component = "artifact-bucket" }, var.tags)
}

resource "aws_s3_bucket" "artifact" {
  bucket = local.bucket_name
  tags   = local.default_tags
}

resource "aws_s3_bucket_versioning" "artifact" {
  bucket = aws_s3_bucket.artifact.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact" {
  bucket = aws_s3_bucket.artifact.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifact" {
  bucket                  = aws_s3_bucket.artifact.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# SSM params so CI can discover bucket + key without hardcoding
resource "aws_ssm_parameter" "bucket_name" {
  name      = "/idlms/artifacts/${var.env_name}/bucket_name"
  type      = "String"
  value     = aws_s3_bucket.artifact.bucket
  overwrite = true
}

resource "aws_ssm_parameter" "artifact_key" {
  name      = "/idlms/artifacts/${var.env_name}/artifact_key"
  type      = "String"
  value     = "website/latest.tar.gz"
  overwrite = true
}
