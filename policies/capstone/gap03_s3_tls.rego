package capstone.soc2.gap03_s3_tls

# SOC 2 CC6.7 - Transmission of data is protected.
# GAP-03: the S3 uploads bucket must have a bucket policy denying
# requests that don't use TLS (aws:SecureTransport = false).

deny contains msg if {
	bucket := input.resource_changes[_]
	bucket.type == "aws_s3_bucket"
	bucket.name == "uploads"

	not tls_policy_exists

	msg := sprintf(
		"SOC 2 CC6.7 [GAP-03]: S3 bucket '%s' has no active aws_s3_bucket_policy denying non-TLS requests. Remediation: add a bucket policy with a Deny statement on condition aws:SecureTransport = false.",
		[bucket.address],
	)
}

tls_policy_exists if {
	pol := input.resource_changes[_]
	pol.type == "aws_s3_bucket_policy"
	pol.name == "uploads_tls_only"
	pol.change.after != null
}