module "s3" {
  source                 = "../../../../platform/container/s3"
  env_name               = var.env_name
  bucket_base_name       = var.bucket_base_name
  bucket_name_override   = null # or set if you want a fixed name
  versioning             = var.versioning
  sse_algorithm          = var.sse_algorithm
  kms_key_id             = null
  force_destroy          = var.force_destroy
  enable_ia_transition   = var.enable_ia_transition
  ia_after_days          = var.ia_after_days
  noncurrent_expire_days = var.noncurrent_expire_days
  expire_after_days      = var.expire_after_days
  create_ssm_params      = var.create_ssm_params
  ssm_path_prefix        = var.ssm_path_prefix
  tags                   = var.tags
}
