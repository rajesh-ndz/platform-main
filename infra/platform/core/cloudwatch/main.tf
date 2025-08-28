provider "aws" { region = var.region }

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  environment = var.environment

  ec2_instance_ids = var.ec2_instance_ids

  nlb_lb_arn_suffix = var.nlb_lb_arn_suffix
  nlb_tg_arn_suffix = var.nlb_tg_arn_suffix

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions

  create_app_log_group = var.create_app_log_group
  app_log_group_name   = var.app_log_group_name
  retention_days       = var.retention_days

  tags = var.tags
}
