output "lb_arn" { value = aws_lb.this.arn }
output "lb_dns_name" { value = aws_lb.this.dns_name }
output "tg_arn" { value = aws_lb_target_group.this.arn }
output "listener_arn" { value = aws_lb_listener.this.arn }
output "lb_arn_suffix" { value = aws_lb.this.arn_suffix }
output "tg_arn_suffix" { value = aws_lb_target_group.this.arn_suffix }


