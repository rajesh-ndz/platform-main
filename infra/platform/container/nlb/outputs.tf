output "lb_dns_name" { value = module.nlb.lb_dns_name }
output "lb_arn" { value = module.nlb.lb_arn }
output "tg_arn" { value = module.nlb.tg_arn }
output "listener_arn" { value = module.nlb.listener_arn }

# For CloudWatch metrics wiring:
output "lb_arn_suffix" { value = module.nlb.lb_arn_suffix }
output "tg_arn_suffix" { value = module.nlb.tg_arn_suffix }
