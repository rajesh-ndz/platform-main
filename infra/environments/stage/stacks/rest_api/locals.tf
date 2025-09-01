locals {
  nlb_dns_name = data.terraform_remote_state.nlb.outputs.lb_dns_name
  # REST API Gateway V1 VPC Link expects NLB ARNs (not target group ARNs)
  vpc_link_target_arns = [data.terraform_remote_state.nlb.outputs.lb_arn]

  common_tags = {
    Name        = "IDLMS-Stage-REST"
    Environment = var.environment
  }
}
