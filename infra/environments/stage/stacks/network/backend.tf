terraform {
  backend "s3" {
    bucket         = "idlms-terraform-state-backend"
    key            = "network/stage/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
