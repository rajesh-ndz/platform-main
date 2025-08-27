# Stage environment
env_name = "stage"
region   = "ap-south-1" # Mumbai
vpc_name = "stage-idlms-vpc"
vpc_cidr = "10.10.0.0/16"

# Prefer same count for AZs and subnets
azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

public_subnet_cidrs  = ["10.10.0.0/20", "10.10.16.0/20", "10.10.32.0/20"]
private_subnet_cidrs = ["10.10.64.0/20", "10.10.80.0/20", "10.10.96.0/20"]

enable_dns_support   = true
enable_dns_hostnames = true
instance_tenancy     = "default"

nat_gateway_mode = "one_per_az" # or "single"

tags = {
  Project     = "IDLMS"
  Environment = "stage"
  Owner       = "Platform"
}
