output "lb_dns_name" {
  description = "DNS name of the NLB"
  value       = aws_lb.this.dns_name
}

output "lb_arn" {
  description = "ARN of the NLB"
  value       = aws_lb.this.arn
}

output "tg_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.this.arn
}

output "listener_arn" {
  description = "ARN of the NLB listener"
  value       = aws_lb_listener.this.arn
}

# ARN suffixes for CloudWatch metrics (no regexreplace needed)
output "lb_arn_suffix" {
  description = "ARN suffix of the NLB (for CW metrics)"
  value       = element(split("loadbalancer/", aws_lb.this.arn), 1)
}

output "tg_arn_suffix" {
  description = "ARN suffix of the target group (for CW metrics)"
  value       = element(split("targetgroup/", aws_lb_target_group.this.arn), 1)
}
