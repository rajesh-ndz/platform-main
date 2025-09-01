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



# ECR plan & apply
export AWS_REGION=ap-south-1

terraform -chdir=infra/environments/stage/stacks/ecr init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/ecr fmt
terraform -chdir=infra/environments/stage/stacks/ecr validate
terraform -chdir=infra/environments/stage/stacks/ecr plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/ecr apply "plan.out"
terraform -chdir=infra/environments/stage/stacks/ecr output

# ECR destroy
terraform -chdir=infra/environments/stage/stacks/ecr init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/ecr plan -destroy -var-file=stage.tfvars -out=destroy.out
terraform -chdir=infra/environments/stage/stacks/ecr apply "destroy.out"

# verify nothing remains tracked
terraform -chdir=infra/environments/stage/stacks/ecr state list || echo "state empty"


# plan & apply
terraform -chdir=infra/environments/stage/stacks/rest_api init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/rest_api fmt
terraform -chdir=infra/environments/stage/stacks/rest_api validate
terraform -chdir=infra/environments/stage/stacks/rest_api plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/rest_api apply "plan.out"
terraform -chdir=infra/environments/stage/stacks/rest_api output

# destroy
terraform -chdir=infra/environments/stage/stacks/rest_api init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/rest_api plan -destroy -var-file=stage.tfvars -out=destroy.out
terraform -chdir=infra/environments/stage/stacks/rest_api apply "destroy.out"

# verify
terraform -chdir=infra/environments/stage/stacks/rest_api state list || echo "state empty"



# plan & apply
terraform -chdir=infra/environments/stage/stacks/s3 init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/s3 fmt
terraform -chdir=infra/environments/stage/stacks/s3 validate
terraform -chdir=infra/environments/stage/stacks/s3 plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/s3 apply "plan.out"
terraform -chdir=infra/environments/stage/stacks/s3 output

# destroy
terraform -chdir=infra/environments/stage/stacks/s3 init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/s3 plan -destroy -var-file=stage.tfvars -out=destroy.out
terraform -chdir=infra/environments/stage/stacks/s3 apply "destroy.out"

# verify
terraform -chdir=infra/environments/stage/stacks/s3 state list || echo "state empty"


# plan & apply
terraform -chdir=infra/environments/stage/stacks/nlb init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/nlb fmt
terraform -chdir=infra/environments/stage/stacks/nlb validate
terraform -chdir=infra/environments/stage/stacks/nlb plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/nlb apply "plan.out"
terraform -chdir=infra/environments/stage/stacks/nlb output

# destroy
terraform -chdir=infra/environments/stage/stacks/nlb init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/nlb plan -destroy -var-file=stage.tfvars -out=destroy.out
terraform -chdir=infra/environments/stage/stacks/nlb apply "destroy.out"

# verify
terraform -chdir=infra/environments/stage/stacks/nlb state list || echo "state empty"


# plan & apply
terraform -chdir=infra/environments/stage/stacks/cloudwatch init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/cloudwatch fmt
terraform -chdir=infra/environments/stage/stacks/cloudwatch validate
terraform -chdir=infra/environments/stage/stacks/cloudwatch plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/cloudwatch apply "plan.out"
terraform -chdir=infra/environments/stage/stacks/cloudwatch output

# destroy
terraform -chdir=infra/environments/stage/stacks/cloudwatch init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/cloudwatch plan -destroy -var-file=stage.tfvars -out=destroy.out
terraform -chdir=infra/environments/stage/stacks/cloudwatch apply "destroy.out"

# verify
terraform -chdir=infra/environments/stage/stacks/cloudwatch state list || echo "state empty"



# plan & apply
terraform -chdir=infra/environments/stage/stacks/ssm init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/ssm fmt
terraform -chdir=infra/environments/stage/stacks/ssm validate
terraform -chdir=infra/environments/stage/stacks/ssm plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/ssm apply "plan.out"
terraform -chdir=infra/environments/stage/stacks/ssm output

# destroy
terraform -chdir=infra/environments/stage/stacks/ssm init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/ssm plan -destroy -var-file=stage.tfvars -out=destroy.out
terraform -chdir=infra/environments/stage/stacks/ssm apply "destroy.out"

# verify
terraform -chdir=infra/environments/stage/stacks/ssm state list || echo "state empty"




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


Create (apply) order ✅

network – VPC, subnets, IGW/NAT (foundation for everything)

ssm – parameters your stacks might read (safe to do early)

cloudwatch – log groups/roles used by API/services

ecr – repos your builds push to (independent of network)

compute – EC2/ECS/EKS/etc. (needs network; usually pulls from ECR; may read SSM; may log to CW)

nlb – needs network subnets; TGs can exist without targets, that’s fine

rest_api – needs the NLB ARN for the VPC Link; uses CloudWatch logs

s3 – independent (do anytime; just don’t manage your TF remote state bucket here)

Destroy order 🧨 (exact reverse)

rest_api

nlb

compute

ecr (optional—keep if CI still uses it)

cloudwatch

ssm

s3 (don’t delete your TF state bucket)

network