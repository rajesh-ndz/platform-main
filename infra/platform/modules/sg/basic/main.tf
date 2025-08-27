resource "aws_security_group" "this" {
  name        = var.name
  description = "Basic security group"
  vpc_id      = var.vpc_id
  tags        = var.tags

  # Ingress rules (from var.ingress_rules)
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Egress rules (from var.egress_rules)
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  # Helps Terraform clean up rules before SG deletion
  revoke_rules_on_delete = true
}
