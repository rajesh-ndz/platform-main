output "ec2_alarms" {
  value = {
    for k, a in aws_cloudwatch_metric_alarm.ec2_status_check : k => a.arn
  }
}

output "nlb_unhealthy_alarm_arn" { value = try(aws_cloudwatch_metric_alarm.nlb_unhealthy[0].arn, null) }
output "nlb_healthy_low_alarm_arn" { value = try(aws_cloudwatch_metric_alarm.nlb_healthy_low[0].arn, null) }

output "log_group_name" {
  value = try(aws_cloudwatch_log_group.app[0].name, null)
}
