package capstone.soc2.gap07_iam_least_priv

test_deny_dynamodb_wildcard if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_iam_role_policy.lambda_inline",
			"type": "aws_iam_role_policy",
			"name": "lambda_inline",
			"change": {"after": {"policy": "{\"Statement\":[{\"Action\":\"dynamodb:*\"}]}"}},
		},
	]}
}

test_deny_s3_wildcard if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_iam_role_policy.lambda_inline",
			"type": "aws_iam_role_policy",
			"name": "lambda_inline",
			"change": {"after": {"policy": "{\"Statement\":[{\"Action\":\"s3:*\"}]}"}},
		},
	]}
}

test_allow_scoped_actions if {
	count(deny) == 0 with input as {"resource_changes": [
		{
			"address": "aws_iam_role_policy.lambda_inline",
			"type": "aws_iam_role_policy",
			"name": "lambda_inline",
			"change": {"after": {"policy": "{\"Statement\":[{\"Action\":[\"dynamodb:PutItem\"]},{\"Action\":[\"s3:PutObject\"]}]}"}},
		},
	]}
}