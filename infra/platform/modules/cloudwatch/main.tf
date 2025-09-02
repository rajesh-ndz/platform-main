terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# App / docker log group
resource "aws_cloudwatch_log_group" "app" {
  name              = var.docker_log_group_name
  retention_in_days = var.retention_in_days
  tags              = merge(var.common_tags, { Name = var.log_group_tag_name })
}

# Optional S3 bucket for NLB access logs
resource "aws_s3_bucket" "nlb_logs" {
  count         = var.access_logs_bucket != "" ? 1 : 0
  bucket        = var.access_logs_bucket
  force_destroy = true
  tags          = merge(var.common_tags, { Name = var.nlb_logs_bucket_tag_name, Environment = var.environment })
}

resource "aws_s3_bucket_public_access_block" "block" {
  count                   = var.access_logs_bucket != "" ? 1 : 0
  bucket                  = aws_s3_bucket.nlb_logs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# NLB Access Logs bucket policy (ELB service principal)
resource "aws_s3_bucket_policy" "nlb_logs_policy" {
  count  = var.access_logs_bucket != "" ? 1 : 0
  bucket = aws_s3_bucket.nlb_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = "AllowELBLogging",
      Effect = "Allow",
      Principal = {
        Service = "logdelivery.elasticloadbalancing.amazonaws.com"
      },
      Action   = "s3:PutObject",
      Resource = "${aws_s3_bucket.nlb_logs[0].arn}/${var.access_logs_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.current.account_id
        },
        ArnLike = {
          "aws:SourceArn" = "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:loadbalancer/net/*"
        }
      }
    }]
  })
}

# SSM parameter holding the CloudWatch Agent config
resource "aws_ssm_parameter" "cw_agent_config" {
  name      = var.ssm_param_name
  type      = "String"
  tier      = "Standard"
  overwrite = true

  value = jsonencode({
    agent = {
      metrics_collection_interval = var.metrics_collection_interval,
      logfile                     = var.cloudwatch_agent_logfile
    },
    logs = {
      logs_collected = {
        files = {
          collect_list = [
            {
              file_path       = var.docker_log_file_path,
              log_group_name  = var.docker_log_group_name,
              log_stream_name = var.log_stream_name,
              timezone        = var.timezone
            }
          ]
        }
      }
    }
  })

  tags = merge(var.common_tags, { Name = var.ssm_tag_name })
}
