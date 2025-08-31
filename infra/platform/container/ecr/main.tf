locals {
  repo_names = var.prefix_with_env ? [for r in var.repositories : "${var.env_name}-${r}"] : var.repositories
}

module "repo" {
  for_each = toset(local.repo_names)
  source   = "../../modules/ecr"

  name                 = each.value
  image_tag_mutability = var.image_tag_mutability
  scan_on_push         = var.scan_on_push
  force_delete         = var.force_delete
  tags                 = merge(var.tags, { Environment = var.env_name })
}

locals {
  repository_urls = [for n in local.repo_names : module.repo[n].repository_url]
  repository_arns = [for n in local.repo_names : module.repo[n].repository_arn]
}
