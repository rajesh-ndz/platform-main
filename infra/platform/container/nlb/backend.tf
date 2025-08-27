# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bckt4321"
#     key            = "container/nlb/terraform.tfstate"
#     region         = "ap-south-1"
#     dynamodb_table = "terraform-state-locks"
#     encrypt        = true
#   }
# }
