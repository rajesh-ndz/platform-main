terraform {
  backend "s3" {
    bucket         = "idlms-terraform-state-backend"
    key            = "stage/network/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "idlms-terraform-locks"
    encrypt        = true
  }
}
