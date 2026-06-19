package capstone.soc2.gap07_iam_least_priv

# SOC 2 CC6.3 - Access is restricted to least privilege.
# GAP-07: the Lambda inline IAM policy must NOT grant wildcard actions
# (dynamodb:* or s3:*) on the workload data stores. It should be scoped
# to the specific actions the handler performs.

deny contains msg if {
	pol := input.resource_changes[_]
	pol.type == "aws_iam_role_policy"
	pol.name == "lambda_inline"

	policy_json := pol.change.after.policy
	contains(policy_json, "dynamodb:*")

	msg := sprintf(
		"SOC 2 CC6.3 [GAP-07]: IAM policy '%s' grants wildcard action 'dynamodb:*'. Remediation: scope to the specific actions used by handler.py (e.g. dynamodb:PutItem).",
		[pol.address],
	)
}

deny contains msg if {
	pol := input.resource_changes[_]
	pol.type == "aws_iam_role_policy"
	pol.name == "lambda_inline"

	policy_json := pol.change.after.policy
	contains(policy_json, "s3:*")

	msg := sprintf(
		"SOC 2 CC6.3 [GAP-07]: IAM policy '%s' grants wildcard action 's3:*'. Remediation: scope to the specific actions used by handler.py (e.g. s3:PutObject).",
		[pol.address],
	)
}