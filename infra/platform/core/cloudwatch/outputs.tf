output "ec2_alarms" { value = module.cloudwatch.ec2_alarms }
output "nlb_unhealthy_alarm_arn" { value = module.cloudwatch.nlb_unhealthy_alarm_arn }
output "nlb_healthy_low_alarm_arn" { value = module.cloudwatch.nlb_healthy_low_alarm_arn }
output "log_group_name" { value = module.cloudwatch.log_group_name }
