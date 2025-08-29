# What alarms are enabled (handy quick check)
output "enabled_alarms" {
  value       = { ec2 = var.enable_ec2_alarms, nlb = var.enable_nlb_alarms }
  description = "Which alarm categories are enabled"
}

# EC2 instance IDs we built alarms for (from locals in main.tf)
output "ec2_instance_ids" {
  value       = try(local.ec2_ids, [])
  description = "EC2 instance IDs covered by alarms"
}
