# VPC Module
Creates a VPC with public/private subnets, IGW, NAT GW(s), routes, and associations.
## Inputs
- env_name, vpc_name, vpc_cidr
- azs (list of AZ names)
- public_subnet_cidrs (list, same length as azs for best mapping)
- private_subnet_cidrs (list, same length as azs)
- enable_dns_support, enable_dns_hostnames, instance_tenancy
- nat_gateway_mode: "single" or "one_per_az"
- tags
## Outputs
- vpc_id, public_subnet_ids, private_subnet_ids, internet_gateway_id, nat_gateway_ids, route tables
