package capstone.soc2.gap04_s3_versioning

test_deny_no_versioning if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_s3_bucket.uploads",
			"type": "aws_s3_bucket",
			"name": "uploads",
			"change": {"after": {}},
		},
	]}
}

test_deny_versioning_suspended if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_s3_bucket.uploads",
			"type": "aws_s3_bucket",
			"name": "uploads",
			"change": {"after": {}},
		},
		{
			"address": "aws_s3_bucket_versioning.uploads",
			"type": "aws_s3_bucket_versioning",
			"name": "uploads",
			"change": {"after": {"versioning_configuration": [{"status": "Suspended"}]}},
		},
	]}
}

test_allow_versioning_enabled if {
	count(deny) == 0 with input as {"resource_changes": [
		{
			"address": "aws_s3_bucket.uploads",
			"type": "aws_s3_bucket",
			"name": "uploads",
			"change": {"after": {}},
		},
		{
			"address": "aws_s3_bucket_versioning.uploads",
			"type": "aws_s3_bucket_versioning",
			"name": "uploads",
			"change": {"after": {"versioning_configuration": [{"status": "Enabled"}]}},
		},
	]}
}