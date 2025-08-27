# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 5.0"
#     }
#   }
# }

locals {
  # Build rules as a list of objects (no compact(strings) misuse)
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

resource "aws_ssm_parameter" "repo_url" {
  count     = var.create_ssm_param && var.ssm_param_name != null ? 1 : 0
  name      = var.ssm_param_name
  type      = "String"
  value     = aws_ecr_repository.this.repository_url
  overwrite = true
  tags      = var.tags
}
