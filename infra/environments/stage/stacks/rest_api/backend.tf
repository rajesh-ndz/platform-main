terraform {
  backend "s3" {
    bucket = "idlms-terraform-state-backend"
    key    = "stage/platform-main/rest_api/terraform.tfstate"
    region = "ap-south-1"
  }
}
