package capstone.soc2.gap05_lambda_vpc

test_deny_no_vpc_config if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_lambda_function.intake",
			"type": "aws_lambda_function",
			"name": "intake",
			"change": {"after": {}},
		},
	]}
}

test_deny_empty_subnets if {
	count(deny) > 0 with input as {"resource_changes": [
		{
			"address": "aws_lambda_function.intake",
			"type": "aws_lambda_function",
			"name": "intake",
			"change": {"after": {"vpc_config": [{"subnet_ids": []}]}},
		},
	]}
}

test_allow_vpc_config if {
	count(deny) == 0 with input as {"resource_changes": [
		{
			"address": "aws_lambda_function.intake",
			"type": "aws_lambda_function",
			"name": "intake",
			"change": {"after": {"vpc_config": [{"subnet_ids": ["subnet-aaa", "subnet-bbb"]}]}},
		},
	]}
}