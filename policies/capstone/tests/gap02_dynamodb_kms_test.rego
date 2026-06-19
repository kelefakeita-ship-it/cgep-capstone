package capstone.soc2.gap02_dynamodb_kms

test_deny_missing_sse if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_dynamodb_table.intake",
			"type": "aws_dynamodb_table",
			"name": "intake",
			"change": {"after": {}},
		},
	]}
}

test_deny_sse_disabled if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_dynamodb_table.intake",
			"type": "aws_dynamodb_table",
			"name": "intake",
			"change": {"after": {"server_side_encryption": [{"enabled": false}]}},
		},
	]}
}

test_allow_sse_enabled if {
	count(deny) == 0 with input as {"resource_changes": [
		{
			"address": "aws_dynamodb_table.intake",
			"type": "aws_dynamodb_table",
			"name": "intake",
			"change": {"after": {"server_side_encryption": [{"enabled": true}]}},
		},
	]}
}