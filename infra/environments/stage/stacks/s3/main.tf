data "aws_caller_identity" "current" {}

locals {
  # Unique-by-account default bucket name (safe in all envs)
  convention_name   = "idlms-${var.env_name}-${var.s3_name}-${data.aws_caller_identity.current.account_id}"
  computed_override = var.use_idlms_artifact_convention && var.bucket_name_override == null ? local.convention_name : var.bucket_name_override
}

module "s3" {
  source = "../../../../platform/container/s3"

  environment = var.env_name
  name        = var.s3_name

  bucket_name_override = local.computed_override

  sse_algorithm = var.sse_algorithm
  kms_key_id    = var.kms_key_id

  versioning    = var.versioning
  force_destroy = var.force_destroy

  enable_ia_transition   = var.enable_ia_transition
  ia_after_days          = var.ia_after_days
  noncurrent_expire_days = var.noncurrent_expire_days
  expire_after_days      = var.expire_after_days

  create_ssm_params = var.create_ssm_params
  ssm_path_prefix   = var.ssm_path_prefix

  tags = merge({ Project = "IDLMS", Environment = var.env_name }, var.tags)
}

output "bucket_name" { value = module.s3.bucket_id }
output "bucket_arn" { value = module.s3.bucket_arn }
output "ssm_bucket_name_param" { value = module.s3.ssm_bucket_name_param }
output "ssm_bucket_arn_param" { value = module.s3.ssm_bucket_arn_param }
