output "nlb_dns_name" {
  value = aws_lb.this.dns_name
}

output "nlb_arn" {
  value = aws_lb.this.arn
}

output "nlb_target_group_arns" {
  value = { for p, tg in aws_lb_target_group.tg : p => tg.arn }
}
