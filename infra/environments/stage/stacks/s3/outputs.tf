output "bucket_name" {
  value = aws_s3_bucket.artifact.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.artifact.arn
}
