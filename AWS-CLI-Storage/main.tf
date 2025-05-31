################################
## AWS S3 Bucket
################################

# REF: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket 

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_s3_bucket" "s3bucketname" {
  bucket        = "bsdbkt${random_string.suffix.result}" # Must be globally unique
  force_destroy = true

  tags = {
    Name        = "BUCKETNAME"
    Environment = "ENV"
  }
}