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
# --- Compute defaults ---
# leave ami_id empty to auto-pick latest Amazon Linux 2023
ami_id        = "ami-02d26659fd82cf299"
instance_type = "t3.micro"
key_name      = null

# Keep SSH disabled (use SSM). To enable SSH from your IP:
# allow_ssh_cidrs = ["<your.ip.address>/32"]
allow_ssh_cidrs = []

# Example app ports (open to 0.0.0.0/0 for now; tighten later or use NLB SG)
allow_app_ports = [4000, 4001, 4002]

# Robust SSM bootstrap for Ubuntu (snap) and Amazon Linux/RHEL/Debian

ecr_repositories = ["api"]

environment = "stage"



name = "idlms-artifacts" # results in "stage-idlms-artifacts" unless you override

# If the computed name is taken globally, set an explicit name:
# bucket_name_override = "stage-idlms-artifacts-592776312448"

versioning    = true
sse_algorithm = "AES256"
force_destroy = false

# Optional lifecycle tuning
enable_ia_transition   = true
ia_after_days          = 30
noncurrent_expire_days = 90
expire_after_days      = 0

create_ssm_params = true
ssm_path_prefix   = "/idlms"


