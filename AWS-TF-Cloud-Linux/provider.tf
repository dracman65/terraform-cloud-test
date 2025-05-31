##############################################################
## Profile to use for deployment. If you setup a profile 
## besides default you can reference it here.
##############################################################
# variable "profile" {
#     description = "AWS credentials profile you want to use"
#     default = "default"
# }

################################
## AWS Provider Module - Main ##
################################

## URL - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#shared-credentials-file

terraform {
  backend "s3" {
    bucket       = "dsd-ec2vpc-state-01"
    key          = "lwebsvrbase01/linwebbase01.tfstate"
    region       = "us-east-1"
    use_lockfile = "true"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# provider "aws" {
#   access_key = var.access_key
#   secret_key = var.secret_key
#   region     = var.region
# }

provider "aws" {
  region                   = var.aws_region
  #shared_credentials_files = ["C:/Users/Digital_Dave/.aws/credentials"]
  #profile                  = "default"
}