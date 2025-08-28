# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 5.0"
#     }
#   }
# }


resource "aws_lb" "this" {
  name                             = var.name
  load_balancer_type               = "network"
  internal                         = var.internal
  subnets                          = var.subnet_ids
  enable_cross_zone_load_balancing = var.cross_zone
  tags                             = var.tags
}


resource "aws_lb_target_group" "this" {
  name        = substr(replace("${var.name}-tg", ".", "-"), 0, 32)
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type


  health_check {
    port     = var.health_check_port
    protocol = var.health_check_protocol
  }


  deregistration_delay = var.deregistration_delay
  tags                 = var.tags
}


# Register targets
resource "aws_lb_target_group_attachment" "instance" {
  count = var.target_type == "instance" ? length(var.target_instance_ids) : 0

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_instance_ids[count.index]
  port             = var.target_port
}


resource "aws_lb_target_group_attachment" "ip" {
  count = var.target_type == "ip" ? length(var.target_ips) : 0

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_ips[count.index]
  port             = var.target_port
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
