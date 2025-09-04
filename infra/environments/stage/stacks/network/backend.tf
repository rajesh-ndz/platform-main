terraform {
  backend "s3" {
    bucket         = "stage-idlms-tfstate-592776312448"
    key            = "network/stage/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
