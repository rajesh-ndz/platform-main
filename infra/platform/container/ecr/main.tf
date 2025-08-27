locals {
  # Derive project from tags to keep names consistent with earlier resources
  project = try(lower(var.tags["Project"]), "idlms")

  # Full valid ECR repo names: <env>-<project>-<short>
  full_repo_names = [
    for r in var.repositories :
    lower(replace("${var.env_name}-${local.project}-${r}", "/[^a-z0-9-\\/]/", "-"))
  ]
}

module "repos" {
  source = "../../modules/ecr/repository"

  repository_names     = local.full_repo_names
  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true
  force_delete         = true
  keep_last_images     = 10
  keep_untagged        = 0
  tags                 = var.tags
}
