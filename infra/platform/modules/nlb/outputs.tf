output "lb_arn" {
  description = "ARN of the Network Load Balancer"
  value       = aws_lb.idlms_nlb.arn
}

output "lb_name" {
  description = "Name of the Network Load Balancer"
  value       = aws_lb.idlms_nlb.name
}

output "lb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.idlms_nlb.dns_name
}

output "lb_zone_id" {
  description = "Route53 hosted zone ID to create an alias record for the NLB"
  value       = aws_lb.idlms_nlb.zone_id
}

output "target_group_arns" {
  description = "Map of port (string) => Target Group ARN"
  value       = { for k, tg in aws_lb_target_group.idlms_tg : k => tg.arn }
}

output "target_group_names" {
  description = "Map of port (string) => Target Group name"
  value       = { for k, tg in aws_lb_target_group.idlms_tg : k => tg.name }
}

output "listener_arns" {
  description = "Map of port (string) => Listener ARN"
  value       = { for k, l in aws_lb_listener.idlms_listener : k => l.arn }
}

output "attachment_ids" {
  description = "List of target group attachment IDs (one per target IP per port)"
  value       = [for a in aws_lb_target_group_attachment.idlms_tg_attachment : a.id]
}
