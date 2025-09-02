terraform -chdir=infra/environments/stage/stacks/network init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/network plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/network apply "plan.out"

terraform -chdir=infra/environments/stage/stacks/compute init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/compute plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/compute apply "plan.out"

terraform -chdir=infra/environments/stage/stacks/nlb init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/nlb plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/nlb apply "plan.out"

terraform -chdir=infra/environments/stage/stacks/ssm init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/ssm plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/ssm apply "plan.out"

terraform -chdir=infra/environments/stage/stacks/rest-api init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/rest-api plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/rest-api apply "plan.out"

terraform -chdir=infra/environments/stage/stacks/ecr init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/ecr plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/ecr apply "plan.out"

terraform -chdir=infra/environments/stage/stacks/s3 init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/s3 plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/s3 apply "plan.out"

terraform -chdir=infra/environments/stage/stacks/cloudwatch init -reconfigure -upgrade
terraform -chdir=infra/environments/stage/stacks/cloudwatch plan -var-file=stage.tfvars -out=plan.out
terraform -chdir=infra/environments/stage/stacks/cloudwatch apply "plan.out"



# 1) CloudWatch
terraform -chdir=infra/environments/stage/stacks/cloudwatch destroy -var-file=stage.tfvars -auto-approve

# 2) REST API
terraform -chdir=infra/environments/stage/stacks/rest-api destroy -var-file=stage.tfvars -auto-approve

# 3) SSM (publishes NLB params — now safe to remove)
terraform -chdir=infra/environments/stage/stacks/ssm destroy -var-file=stage.tfvars -auto-approve

# 4) NLB (will also remove TG attachments & SG rules it created)
terraform -chdir=infra/environments/stage/stacks/nlb destroy -var-file=stage.tfvars -auto-approve

# 5) Compute (EC2, SG, IAM instance profile/role if managed here)
terraform -chdir=infra/environments/stage/stacks/compute destroy -var-file=stage.tfvars -auto-approve

# 6) ECR (independent; your module is configured with force_delete=true)
terraform -chdir=infra/environments/stage/stacks/ecr destroy -var-file=stage.tfvars -auto-approve

# 7) S3 (independent; bucket must be empty if force delete is not enabled)
# If destroy fails with "BucketNotEmpty", empty then destroy:
#   aws s3 rm s3://<your-bucket-name> --recursive --region ap-south-1
terraform -chdir=infra/environments/stage/stacks/s3 destroy -var-file=stage.tfvars -auto-approve

# 8) Network (VPC + subnets last)
terraform -chdir=infra/environments/stage/stacks/network destroy -var-file=stage.tfvars -auto-approve


Tips if you hit common blockers

“already exists / import required” during destroy → that resource wasn’t in TF state (pre-existing). Either import then destroy, or leave it.

S3 bucket not empty → empty it first:

aws s3 rm s3://<your-bucket-name> --recursive --region ap-south-1


ECR repo not empty (if force_delete=false in your module) → delete images first:

aws ecr list-images --repository-name <repo> --query 'imageIds[*]' --output json | \
jq -c '.' | xargs -I{} aws ecr batch-delete-image --repository-name <repo> --image-ids '{}' --region ap-south-1


State lock stuck (rare): note the LockID and force unlock:

terraform -chdir=<stack> force-unlock <LOCK_ID>


Want a single bash script that tears everything down in that order with safety checks? I can drop one in your exact paths.