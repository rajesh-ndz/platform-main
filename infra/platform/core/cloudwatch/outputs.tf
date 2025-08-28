output "ec2_alarm_names" {
  value = [for a in aws_cloudwatch_metric_alarm.ec2_status_check : a.alarm_name]
}

output "nlb_alarm_names" {
  value = concat(
    [for a in aws_cloudwatch_metric_alarm.nlb_unhealthy : a.alarm_name],
    [for a in aws_cloudwatch_metric_alarm.nlb_healthy_low : a.alarm_name]
  )
}

# IMPORTANT: don't reference a resource here (module may be targeted/planned without creating it)
# Just return the configured name (or null) so plan never breaks.
output "log_group_name" {
  value = var.create_app_log_group && var.app_log_group_name != null ? var.app_log_group_name : null
}
