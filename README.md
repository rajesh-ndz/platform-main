# platform-main

# Network plan and apply
terraform -chdir=infra/environments/stage/stacks/network init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/network fmt
terraform -chdir=infra/environments/stage/stacks/network validate
terraform -chdir=infra/environments/stage/stacks/network plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/network apply "plan.out"
terraform -chdir=infra/environments/stage/stacks/network output
# Network Destroy
terraform -chdir=infra/environments/stage/stacks/network init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/network plan -destroy -var-file=stage.tfvars -out=destroy.out
terraform -chdir=infra/environments/stage/stacks/network apply "destroy.out"
# verify nothing remains tracked
terraform -chdir=infra/environments/stage/stacks/network state list || echo "state empty"


# Compute plan and apply
terraform -chdir=infra/environments/stage/stacks/compute init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/compute fmt
terraform -chdir=infra/environments/stage/stacks/compute validate
terraform -chdir=infra/environments/stage/stacks/compute plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/compute apply "plan.out"
terraform -chdir=infra/environments/stage/stacks/network output
# compute destroy
terraform -chdir=infra/environments/stage/stacks/compute init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/compute plan -destroy -var-file=stage.tfvars -out=destroy.out
terraform -chdir=infra/environments/stage/stacks/compute apply "destroy.out"
# verify nothing remains tracked
terraform -chdir=infra/environments/stage/stacks/compute state list || echo "state empty"





# To see only out puts

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
