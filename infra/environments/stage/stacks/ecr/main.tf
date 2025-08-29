module "ecr" {
  source               = "../../../../platform/container/ecr"
  env_name             = var.env_name
  repositories         = var.repositories
  image_tag_mutability = var.image_tag_mutability
  keep_last_images     = var.keep_last_images
  create_ssm_params    = var.create_ssm_params
  ssm_path_prefix      = var.ssm_path_prefix
  tags                 = var.tags
}

output "repo_arns" { value = module.ecr.repository_arns }
output "repo_urls" { value = module.ecr.repository_urls }
