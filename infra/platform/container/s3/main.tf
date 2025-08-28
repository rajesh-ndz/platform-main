provider "aws" { region = var.region }

data "aws_caller_identity" "current" {}

locals {
  # Deterministic, globally-unique-style names that match your style and avoid conflicts
  artifacts_bucket = "${var.environment}-idlms-artifacts-${data.aws_caller_identity.current.account_id}"
  logs_bucket      = "${var.environment}-idlms-logs-${data.aws_caller_identity.current.account_id}"

  common_tags = merge({
    Project     = "IDLMS"
    Environment = var.environment
    Owner       = "Platform"
  }, var.tags)
}

module "artifacts" {
  source = "../../modules/s3_bucket"

  bucket_name         = local.artifacts_bucket
  enable_versioning   = true
  block_public_access = true
  tags                = local.common_tags

  # SSM params for reuse by other stacks/pipelines
  ssm_param_bucket_name = "/idlms/${var.environment}/s3/artifacts/bucket_name"
  ssm_param_bucket_arn  = "/idlms/${var.environment}/s3/artifacts/bucket_arn"
}

module "logs" {
  source = "../../modules/s3_bucket"

  bucket_name         = local.logs_bucket
  enable_versioning   = true
  block_public_access = true
  tags                = local.common_tags

  ssm_param_bucket_name = "/idlms/${var.environment}/s3/logs/bucket_name"
  ssm_param_bucket_arn  = "/idlms/${var.environment}/s3/logs/bucket_arn"
}

