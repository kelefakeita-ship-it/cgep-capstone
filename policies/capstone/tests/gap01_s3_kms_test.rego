package capstone.soc2.gap01_s3_kms

test_deny_missing_encryption if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_s3_bucket.uploads",
			"type": "aws_s3_bucket",
			"name": "uploads",
			"change": {"after": {}},
		},
	]}
}

test_deny_wrong_algorithm if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_s3_bucket.uploads",
			"type": "aws_s3_bucket",
			"name": "uploads",
			"change": {"after": {}},
		},
		{
			"address": "aws_s3_bucket_server_side_encryption_configuration.uploads",
			"type": "aws_s3_bucket_server_side_encryption_configuration",
			"name": "uploads",
			"change": {"after": {"rule": [{"apply_server_side_encryption_by_default": [{"sse_algorithm": "AES256"}]}]}},
		},
	]}
}

test_allow_kms_encryption if {
	count(deny) == 0 with input as {"resource_changes": [
		{
			"address": "aws_s3_bucket.uploads",
			"type": "aws_s3_bucket",
			"name": "uploads",
			"change": {"after": {}},
		},
		{
			"address": "aws_s3_bucket_server_side_encryption_configuration.uploads",
			"type": "aws_s3_bucket_server_side_encryption_configuration",
			"name": "uploads",
			"change": {"after": {"rule": [{"apply_server_side_encryption_by_default": [{"sse_algorithm": "aws:kms"}]}]}},
		},
	]}
}
