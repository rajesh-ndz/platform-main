# Prod environment
env_name  = "prod"
region    = "eu-west-1"  # Ireland
vpc_name  = "prod-idlms-vpc"
vpc_cidr  = "10.20.0.0/16"

azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

public_subnet_cidrs  = ["10.20.0.0/20", "10.20.16.0/20", "10.20.32.0/20"]
private_subnet_cidrs = ["10.20.64.0/20", "10.20.80.0/20", "10.20.96.0/20"]

enable_dns_support   = true
enable_dns_hostnames = true
instance_tenancy     = "default"

nat_gateway_mode = "one_per_az"  # or "single"

tags = {
  Project     = "IDLMS"
  Environment = "prod"
  Owner       = "Platform"
}
