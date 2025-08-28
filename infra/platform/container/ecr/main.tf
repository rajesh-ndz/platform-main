locals {
  final_repo_names = var.prefix_with_env ? [for r in var.repositories : "${var.env_name}-${r}"] : var.repositories
  ssm_prefix       = coalesce(var.ssm_path_prefix, "/idlms/${var.env_name}/ecr")
}

module "repos" {
  source = "../../modules/ecr/repository"

  repository_names     = local.final_repo_names
  image_tag_mutability = var.image_tag_mutability
  scan_on_push         = var.scan_on_push
  force_delete         = var.force_delete
  encryption_type      = var.encryption_type
  kms_key_id           = var.kms_key_id

  keep_untagged    = var.keep_untagged
  keep_last_images = var.keep_last_images
  additional_rules = var.additional_rules

  create_ssm_params = var.create_ssm_params
  ssm_path_prefix   = local.ssm_prefix

  tags = merge(var.tags, {
    Environment = var.env_name
  })
}
