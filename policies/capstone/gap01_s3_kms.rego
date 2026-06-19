package capstone.soc2.gap01_s3_kms

# SOC 2 CC6.1 — Logical access security measures protect data at rest.
# GAP-01: the S3 uploads bucket must use SSE-KMS with a customer-managed
# key, not the AWS-managed SSE-S3 default. PHI keys must stay under
# customer custody.

deny contains msg if {
	bucket := input.resource_changes[_]
	bucket.type == "aws_s3_bucket"
	bucket.name == "uploads"

	not kms_encryption_exists

	msg := sprintf(
		"SOC 2 CC6.1 [GAP-01]: S3 bucket '%s' has no matching aws_s3_bucket_server_side_encryption_configuration with sse_algorithm=aws:kms. Remediation: add an aws_s3_bucket_server_side_encryption_configuration resource (name = \"uploads\") with apply_server_side_encryption_by_default.sse_algorithm = \"aws:kms\".",
		[bucket.address],
	)
}

kms_encryption_exists if {
	enc := input.resource_changes[_]
	enc.type == "aws_s3_bucket_server_side_encryption_configuration"
	enc.name == "uploads"
	rule := enc.change.after.rule[_]
	rule.apply_server_side_encryption_by_default[_].sse_algorithm == "aws:kms"
}