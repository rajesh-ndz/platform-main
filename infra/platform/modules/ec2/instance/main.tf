# Only look up an AMI if ami_id is empty (avoids ec2:DescribeImages when you pass an AMI)
data "aws_ami" "al2023" {
  count       = length(trimspace(var.ami_id)) == 0 ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  use_lookup = length(trimspace(var.ami_id)) == 0
  chosen_ami = local.use_lookup ? data.aws_ami.al2023[0].id : var.ami_id

  default_user_data = <<-EOT
    #!/bin/bash
    # Ensure SSM agent is running (AL2023 has it by default)
    systemctl enable --now amazon-ssm-agent || true
  EOT
}

resource "aws_instance" "this" {
  ami                         = local.chosen_ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  user_data                   = coalesce(var.user_data, local.default_user_data)
  user_data_replace_on_change = true


  # Inherits private/public IP behavior from the subnet (private subnets won't assign public IPs)
  tags = merge(var.tags, { Name = var.name })
  lifecycle {
    create_before_destroy = true
  }
}
