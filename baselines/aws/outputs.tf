# outputs.tf
output "cloudtrail_name" {
  value       = aws_cloudtrail.mgmt.name
  description = "Name of the multi-region management CloudTrail."
}

output "cloudtrail_bucket" {
  value       = aws_s3_bucket.trail.id
  description = "S3 bucket holding CloudTrail logs."
}

output "securityhub_arn" {
  value       = aws_securityhub_account.this.id
  description = "Security Hub account ID (confirms it is enabled)."
}