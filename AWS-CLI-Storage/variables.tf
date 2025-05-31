################################
## AWS Bucket Region
################################

variable "aws_region" {
  type        = string
  description = "AWS region to use for resources."
  default     = "us-east-1"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID."
  default     = "498219995853"
}

# variable "aws_azs" {
#  type = string
#  description = "AWS Availability Zones"
#  default = "us-east-1a"
# }

# Used if more than 2 tags are required.
# variable "aws_bucket_tags" {
#   description = "Basic Tags"
#   type        = map(string)
#   default = {
#     name        = "dsd-test-aws",
#     deployed_by = "terraform",
#     owner       = "digital_dave"
#     environment = "snbx-test-01"
#     chargecode  = "09743217"
#   }
# }