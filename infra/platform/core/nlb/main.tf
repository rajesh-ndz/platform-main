locals {
  ports_str = toset([for p in var.ports : tostring(p)])

  attach_keys_instance = var.target_type == "instance" ? flatten([for p in local.ports_str : [for id in var.target_instance_ids : "${p}::${id}"]]) : []

  attach_map_instance = { for k in local.attach_keys_instance : k => k }

  attach_keys_ip = var.target_type == "ip" ? flatten([for p in local.ports_str : [for ip in var.target_ip_addresses : "${p}::${ip}"]]) : []

  attach_map_ip = { for k in local.attach_keys_ip : k => k }
}

resource "aws_lb" "this" {
  name                             = "${var.env_name}-idlms-nlb"
  load_balancer_type               = "network"
  internal                         = var.internal
  subnets                          = var.subnet_ids
  enable_cross_zone_load_balancing = var.cross_zone

  tags = merge(var.tags, { Name = "${var.env_name}-idlms-nlb" })
}

resource "aws_lb_target_group" "tg" {
  for_each = local.ports_str

  name        = "${var.env_name}-tg-${each.key}"
  port        = tonumber(each.key)
  protocol    = "TCP"
  target_type = var.target_type
  vpc_id      = var.vpc_id

  health_check {
    protocol = "TCP"
    port     = "traffic-port"
  }

  tags = merge(var.tags, { Name = "${var.env_name}-tg-${each.key}" })
}

resource "aws_lb_listener" "ln" {
  for_each         = toset([for p in var.ports : tostring(p)])
  load_balancer_arn = aws_lb.this.arn
  port             = tonumber(each.key)
  protocol         = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }
  tcp_idle_timeout_seconds = 350
}

}

resource "aws_lb_target_group_attachment" "inst" {
  for_each = local.attach_map_instance

  target_group_arn = aws_lb_target_group.tg[split("::", each.key)[0]].arn
  target_id        = split("::", each.key)[1]
  port             = tonumber(split("::", each.key)[0])
}

resource "aws_lb_target_group_attachment" "ip" {
  for_each = local.attach_map_ip

  target_group_arn = aws_lb_target_group.tg[split("::", each.key)[0]].arn
  target_id        = split("::", each.key)[1]
  port             = tonumber(split("::", each.key)[0])
}

# --- Optional NLB security group and rules ---
resource "aws_security_group" "nlb" {
  count       = var.create_nlb_sg ? 1 : 0
  name        = "${var.nlb_name}-sg"
  description = "Ingress to NLB listeners"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.nlb_name}-sg" })
}

# Build all (port, cidr) pairs so we can create one rule per combo
locals {
  nlb_port_cidrs = flatten([
    for p in var.ports : [
      for c in var.nlb_allowed_cidrs : { port = p, cidr = c }
    ]
  ])
}

resource "aws_vpc_security_group_ingress_rule" "nlb_in" {
  for_each = var.create_nlb_sg ? { for pc in local.nlb_port_cidrs : "${pc.port}-${pc.cidr}" => pc } : {}
  security_group_id = aws_security_group.nlb[0].id
  ip_protocol       = "tcp"
  from_port         = each.value.port
  to_port           = each.value.port
  cidr_ipv4         = each.value.cidr
}

resource "aws_vpc_security_group_egress_rule" "nlb_all" {
  count             = var.create_nlb_sg ? 1 : 0
  security_group_id = aws_security_group.nlb[0].id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
