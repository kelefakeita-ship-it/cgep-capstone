package capstone.soc2.gap03_s3_tls

test_deny_missing_policy if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_s3_bucket.uploads",
			"type": "aws_s3_bucket",
			"name": "uploads",
			"change": {"after": {}},
		},
	]}
}

test_deny_policy_being_deleted if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_s3_bucket.uploads",
			"type": "aws_s3_bucket",
			"name": "uploads",
			"change": {"after": {}},
		},
		{
			"address": "aws_s3_bucket_policy.uploads_tls_only",
			"type": "aws_s3_bucket_policy",
			"name": "uploads_tls_only",
			"change": {"after": null},
		},
	]}
}

test_allow_policy_present if {
	count(deny) == 0 with input as {"resource_changes": [
		{
			"address": "aws_s3_bucket.uploads",
			"type": "aws_s3_bucket",
			"name": "uploads",
			"change": {"after": {}},
		},
		{
			"address": "aws_s3_bucket_policy.uploads_tls_only",
			"type": "aws_s3_bucket_policy",
			"name": "uploads_tls_only",
			"change": {"after": {"policy": "{...}"}},
		},
	]}
}