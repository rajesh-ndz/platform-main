locals {
  rules = concat(
    var.keep_untagged > 0 ? [
      {
        rulePriority = 1
        description  = "Expire untagged images beyond count"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = var.keep_untagged
        }
        action = { type = "expire" }
      }
    ] : [],
    [
      {
        rulePriority = 2
        description  = "Keep last N images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.keep_last_images
        }
        action = { type = "expire" }
      }
    ],
    var.additional_rules
  )

  lifecycle_policy_json = jsonencode({ rules = local.rules })
}

resource "aws_ecr_repository" "this" {
  for_each = toset(var.repository_names)

  name                 = each.value
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key_id : null
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = aws_ecr_repository.this
  repository = each.value.name
  policy     = local.lifecycle_policy_json
}

# One SSM parameter per repository (if enabled)
resource "aws_ssm_parameter" "repo_url" {
  for_each = var.create_ssm_params && var.ssm_path_prefix != null ? aws_ecr_repository.this : {}

  name      = "${var.ssm_path_prefix}/${each.key}/repository_url"
  type      = "String"
  value     = each.value.repository_url
  overwrite = true
  tags      = var.tags
}
