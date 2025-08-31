terraform {
  backend "s3" {
    bucket         = "idlms-terraform-state-backend"
    key            = "stage/container/nlb/terraform.tfstate" # <- new unique key
    region         = "ap-south-1"
    dynamodb_table = "idlms-terraform-locks"
    encrypt        = true
  }
}
