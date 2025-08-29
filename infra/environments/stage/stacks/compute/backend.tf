terraform {
  backend "s3" {
    bucket         = "idlms-terraform-state-backend"
    key            = "stage/compute/terraform.tfstate" # ← NOT the network key
    region         = "ap-south-1"
    dynamodb_table = "idlms-terraform-locks"
    encrypt        = true
  }
}
