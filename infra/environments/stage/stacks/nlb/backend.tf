terraform {
  backend "s3" {
    bucket = "idlms-terraform-state-backend"
    key    = "nlb/stage/terraform.tfstate"
    region = "ap-south-1"
  }
}
