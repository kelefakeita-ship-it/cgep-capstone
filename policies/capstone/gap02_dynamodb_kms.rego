package capstone.soc2.gap02_dynamodb_kms

# SOC 2 CC6.1 - Logical access security measures protect data at rest.
# GAP-02: the DynamoDB submissions table must declare an explicit
# server_side_encryption block (customer-managed key), not rely on
# the AWS-owned default. Note: kms_key_arn is a forward reference to
# aws_kms_key.phi and is unknown at plan time, so this policy checks
# for the explicit block + enabled=true; the literal CMK wiring is
# confirmed by Terraform source review / OSCAL documentation.

deny contains msg if {
	table := input.resource_changes[_]
	table.type == "aws_dynamodb_table"
	table.name == "intake"

	not has_explicit_encryption(table)

	msg := sprintf(
		"SOC 2 CC6.1 [GAP-02]: DynamoDB table '%s' has no explicit server_side_encryption block with enabled=true. Without it the table falls back to the AWS-owned default key. Remediation: add server_side_encryption { enabled = true, kms_key_arn = aws_kms_key.phi.arn }.",
		[table.address],
	)
}

has_explicit_encryption(table) if {
	sse := table.change.after.server_side_encryption[_]
	sse.enabled == true
}