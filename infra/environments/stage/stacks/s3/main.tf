module "s3" {
  source            = "../../../../platform/container/s3"
  env_name          = var.env_name
  region            = var.region
  bucket_base_name  = var.bucket_base_name
  versioning        = var.versioning
  sse_algorithm     = var.sse_algorithm
  force_destroy     = var.force_destroy
  enable_ia_transition   = var.enable_ia_transition
  ia_after_days          = var.ia_after_days
  noncurrent_expire_days = var.noncurrent_expire_days
  expire_after_days      = var.expire_after_days
  create_ssm_params      = var.create_ssm_params
  ssm_path_prefix        = var.ssm_path_prefix
  tags                   = var.tags
}

output "bucket_name" { value = module.s3.bucket_name }
