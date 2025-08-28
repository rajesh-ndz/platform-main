locals {
  # Booleans must control counts (not unknown strings)
  do_ec2 = var.enable_ec2_alarms
  do_nlb = var.enable_nlb_alarms
}

# --- EC2 Status Check Failed (per instance) ---
resource "aws_cloudwatch_metric_alarm" "ec2_status_check" {
  for_each = local.do_ec2 ? { for idx, id in var.ec2_instance_ids : tostring(idx) => id } : {}

  alarm_name          = "idlms-${var.environment}-ec2-${each.value}-statuscheckfailed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  treat_missing_data  = "breaching"

  dimensions = {
    InstanceId = each.value
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}

# --- NLB alarms (single) ---
resource "aws_cloudwatch_metric_alarm" "nlb_unhealthy" {
  count = local.do_nlb ? 1 : 0

  alarm_name          = "idlms-${var.environment}-nlb-unhealthyhosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  dimensions = {
    TargetGroup  = var.nlb_tg_arn_suffix
    LoadBalancer = var.nlb_lb_arn_suffix
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "nlb_healthy_low" {
  count = local.do_nlb ? 1 : 0

  alarm_name          = "idlms-${var.environment}-nlb-lowhealthy"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  treat_missing_data  = "breaching"

  dimensions = {
    TargetGroup  = var.nlb_tg_arn_suffix
    LoadBalancer = var.nlb_lb_arn_suffix
  }

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}

