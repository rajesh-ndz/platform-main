terraform {
  backend "s3" {
    bucket         = "idlms-terraform-state-backend"
    key            = "stage/s3/terraform.tfstate" # UNIQUE to s3 stack
    region         = "ap-south-1"
    dynamodb_table = "idlms-terraform-locks"
    encrypt        = true
  }
}
