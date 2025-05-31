################################
## AWS Output Values - Bucket
################################

output "aws_s3_bucket" {
  value       = aws_s3_bucket.s3bucketname
  description = "The name of the bucket"
}