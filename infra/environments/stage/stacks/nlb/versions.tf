terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # Keep it broad so Terraform can fetch a compatible version
      version = ">= 5.0.0, < 7.0"
    }
  }
}
