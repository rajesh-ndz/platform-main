terraform {
  backend "s3" {
    bucket       = "idlms-terraform-state-backend"
    key          = "rest-api/stage/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
