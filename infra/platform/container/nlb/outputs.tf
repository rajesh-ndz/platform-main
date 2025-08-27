output "lb_dns_name" {
  description = "DNS name of the NLB"
  value       = module.nlb.lb_dns_name
}

output "lb_arn" {
  description = "ARN of the NLB"
  value       = module.nlb.lb_arn
}

output "tg_arn" {
  description = "ARN of the target group"
  value       = module.nlb.tg_arn
}

output "listener_arn" {
  description = "ARN of the NLB listener"
  value       = module.nlb.listener_arn
}
