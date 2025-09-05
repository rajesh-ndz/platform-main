terraform {
  backend "s3" {
    bucket       = "idlms-terraform-state-backend"
    key          = "s3/stage/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
