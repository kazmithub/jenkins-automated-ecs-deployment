# Terraform Backend Configuration
# Uncomment the block below and configure with your S3 bucket and DynamoDB table
# to enable remote state management.
#
# Prerequisites:
#   1. Create an S3 bucket for state storage (enable versioning)
#   2. Create a DynamoDB table for state locking (partition key: LockID)
#
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "jenkins-automated-ecs-deployment/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
# }
