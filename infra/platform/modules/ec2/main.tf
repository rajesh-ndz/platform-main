terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = ">= 5.0"
    }
  }
}

resource "aws_instance" "idlms_ec2" {
  ami                         = lookup(var.amis, var.aws_region)
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.instance_profile_name
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address

  tags = merge(var.ec2_tags, { Name = var.name })
}
