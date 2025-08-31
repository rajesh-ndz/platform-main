terraform {
  backend "s3" {
    bucket       = "idlms-terraform-state-backend"
    key          = "stage/observability/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
