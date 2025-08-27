output "lb_arn" { value = aws_lb.this.arn }
output "lb_dns_name" { value = aws_lb.this.dns_name }
output "tg_arn" { value = aws_lb_target_group.this.arn }
output "listener_arn" { value = aws_lb_listener.this.arn }
