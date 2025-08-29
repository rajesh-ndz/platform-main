# platform-main
platform-main


# Network
terraform -chdir=infra/environments/stage/stacks/network   output

# Compute
terraform -chdir=infra/environments/stage/stacks/compute   output

# NLB
terraform -chdir=infra/environments/stage/stacks/nlb       output

# REST API
terraform -chdir=infra/environments/stage/stacks/rest_api  output

# ECR
terraform -chdir=infra/environments/stage/stacks/ecr       output

# S3
terraform -chdir=infra/environments/stage/stacks/s3        output

# CloudWatch (may be empty if we didn’t define outputs there)
terraform -chdir=infra/environments/stage/stacks/cloudwatch output
