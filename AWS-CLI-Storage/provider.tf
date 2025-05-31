
# terraform {

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#     random = {
#       source  = "hashicorp/random"
#       version = "> 3.5.1"
#     }
#   }
# }

# # provider "aws" {
# #   access_key = var.access_key
# #   secret_key = var.secret_key
# #   region     = var.region
# # }

provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["C:/Users/Digital_Dave/.aws/credentials"]
  #profile                  = "default"
  allowed_account_ids      = [var.aws_account_id]
}

terraform { 
  cloud { 
    
    organization = "DSD-Terraform-Test" 

    workspaces { 
      name = "AWS-CLI-Workflow" 
    } 
  } 
}