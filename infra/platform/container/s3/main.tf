# Inherit provider/region from the stack (no provider block here)

data "aws_region" "current" {}

locals {
  bucket_name = (
    var.bucket_name_override != null && trim(var.bucket_name_override) != ""
  ) ? var.bucket_name_override : "${var.bucket_base_name}-${var.env_name}"

  common_tags = merge(var.tags, { Environment = var.env_name })
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy
  tags          = local.common_tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration { status = var.versioning ? "Enabled" : "Suspended" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" && var.kms_key_id != null ? var.kms_key_id : null
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.enable_ia_transition ? [1] : []
    content {
      id     = "standard-to-ia"
      status = "Enabled"
      transition {
        days          = var.ia_after_days
        storage_class = "STANDARD_IA"
      }
      noncurrent_version_expiration {
        noncurrent_days = var.noncurrent_expire_days
      }
    }
  }

  dynamic "rule" {
    for_each = var.expire_after_days > 0 ? [1] : []
    content {
      id     = "expire-current-objects"
      status = "Enabled"
      expiration { days = var.expire_after_days }
    }
  }
}

# Optional: publish identifiers into SSM for pipelines
resource "aws_ssm_parameter" "bucket_name" {
  count = var.create_ssm_params ? 1 : 0
  name  = "${var.ssm_path_prefix}/s3/${var.env_name}/bucket_name"
  type  = "String"
  value = aws_s3_bucket.this.bucket
  tags  = local.common_tags
}

resource "aws_ssm_parameter" "bucket_arn" {
  count = var.create_ssm_params ? 1 : 0
  name  = "${var.ssm_path_prefix}/s3/${var.env_name}/bucket_arn"
  type  = "String"
  value = aws_s3_bucket.this.arn
  tags  = local.common_tags
}
