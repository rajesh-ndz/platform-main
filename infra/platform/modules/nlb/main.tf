terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# ── Load Balancer ───────────────────────────────────────────────────────────────
resource "aws_lb" "idlms_nlb" {
  name                             = var.name
  load_balancer_type               = var.load_balancer_type # should be "network"
  internal                         = var.internal
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      subnet_id            = subnet_mapping.value.subnet_id
      allocation_id        = try(subnet_mapping.value.allocation_id, null)
      private_ipv4_address = try(subnet_mapping.value.private_ipv4_address, null)
      ipv6_address         = try(subnet_mapping.value.ipv6_address, null)
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

# ── One Target Group per Port ───────────────────────────────────────────────────
resource "aws_lb_target_group" "idlms_tg" {
  for_each = { for port in var.additional_ports : tostring(port) => port }

  name        = "${var.name}-tg-${each.key}" # NOTE: keep under 32 chars total
  port        = each.value
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    protocol            = "TCP"
    port                = each.value
    healthy_threshold   = var.hc_healthy_threshold
    unhealthy_threshold = var.hc_unhealthy_threshold
    timeout             = var.hc_timeout
    interval            = var.hc_interval
  }

  tags = merge(var.tags, { Name = "${var.name}-tg-${each.key}" })
}

# ── Attach every target IP to every port’s TG ───────────────────────────────────
locals {
  port_ip_pairs = flatten([
    for port in var.additional_ports : [
      for ip in var.target_ips : {
        port = port
        ip   = ip
        key  = "${port}-${ip}"
      }
    ]
  ])
}

resource "aws_lb_target_group_attachment" "idlms_tg_attachment" {
  for_each = { for combo in local.port_ip_pairs : combo.key => combo }

  target_group_arn = aws_lb_target_group.idlms_tg[tostring(each.value.port)].arn
  target_id        = each.value.ip
  port             = each.value.port
}

# ── One Listener per Port ──────────────────────────────────────────────────────
resource "aws_lb_listener" "idlms_listener" {
  for_each          = { for port in var.additional_ports : tostring(port) => port }
  load_balancer_arn = aws_lb.idlms_nlb.arn
  port              = each.value
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.idlms_tg[each.key].arn
  }
}
