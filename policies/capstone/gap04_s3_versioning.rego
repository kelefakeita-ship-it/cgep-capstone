package capstone.soc2.gap04_s3_versioning

# SOC 2 A1.2 - Availability: environmental protections and recovery.
# GAP-04: the S3 uploads bucket must have versioning enabled so PHI
# overwrites are recoverable.

deny contains msg if {
	bucket := input.resource_changes[_]
	bucket.type == "aws_s3_bucket"
	bucket.name == "uploads"

	not versioning_enabled

	msg := sprintf(
		"SOC 2 A1.2 [GAP-04]: S3 bucket '%s' has no matching aws_s3_bucket_versioning with status=Enabled. PHI overwrites would be unrecoverable. Remediation: add an aws_s3_bucket_versioning resource (name = \"uploads\") with versioning_configuration.status = \"Enabled\".",
		[bucket.address],
	)
}

versioning_enabled if {
	v := input.resource_changes[_]
	v.type == "aws_s3_bucket_versioning"
	v.name == "uploads"
	v.change.after.versioning_configuration[_].status == "Enabled"
}