locals {
  has_nlb = (
    var.nlb_lb_arn_suffix != null && var.nlb_lb_arn_suffix != "" &&
    var.nlb_tg_arn_suffix != null && var.nlb_tg_arn_suffix != ""
  )
}

# Optional Log Group (for future use by CW Agent / app)
resource "aws_cloudwatch_log_group" "app" {
  count             = var.create_app_log_group ? 1 : 0
  name              = coalesce(var.app_log_group_name, "/idlms/${var.environment}/app")
  retention_in_days = var.retention_days
  tags              = var.tags
}

# EC2 Status Check Failed (any) >= 1
resource "aws_cloudwatch_metric_alarm" "ec2_status_check" {
  for_each = toset(var.ec2_instance_ids)

  alarm_name          = "${var.environment}-ec2-${each.value}-statuscheck"
  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 2

  dimensions = { InstanceId = each.value }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  tags                      = var.tags
}

# NLB: UnHealthyHostCount > 0
resource "aws_cloudwatch_metric_alarm" "nlb_unhealthy" {
  count = local.has_nlb ? 1 : 0

  alarm_name          = "${var.environment}-nlb-unhealthy-hosts"
  namespace           = "AWS/NLB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Average"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  period              = 60
  evaluation_periods  = 2

  dimensions = {
    LoadBalancer = var.nlb_lb_arn_suffix
    TargetGroup  = var.nlb_tg_arn_suffix
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  tags                      = var.tags
}

# NLB: HealthyHostCount < 1
resource "aws_cloudwatch_metric_alarm" "nlb_healthy_low" {
  count = local.has_nlb ? 1 : 0

  alarm_name          = "${var.environment}-nlb-healthy-host-low"
  namespace           = "AWS/NLB"
  metric_name         = "HealthyHostCount"
  statistic           = "Minimum"
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  period              = 60
  evaluation_periods  = 2

  dimensions = {
    LoadBalancer = var.nlb_lb_arn_suffix
    TargetGroup  = var.nlb_tg_arn_suffix
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions
  tags                      = var.tags
}
locals {
  prefix = coalesce(var.prefix, "idlms-${var.environment}")
}
