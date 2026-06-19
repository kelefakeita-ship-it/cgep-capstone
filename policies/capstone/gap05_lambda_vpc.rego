package capstone.soc2.gap05_lambda_vpc

# SOC 2 CC6.6 - Logical access is restricted via network segmentation.
# GAP-05: the intake Lambda must run inside the VPC's private subnets
# (vpc_config with at least one subnet), not the default public Lambda
# environment.

deny contains msg if {
	fn := input.resource_changes[_]
	fn.type == "aws_lambda_function"
	fn.name == "intake"

	not has_vpc_config(fn)

	msg := sprintf(
		"SOC 2 CC6.6 [GAP-05]: Lambda function '%s' has no vpc_config with subnet_ids. It runs in the default Lambda environment instead of the private subnets. Remediation: add vpc_config { subnet_ids = aws_subnet.private[*].id, security_group_ids = [aws_security_group.lambda.id] }.",
		[fn.address],
	)
}

has_vpc_config(fn) if {
	vpc := fn.change.after.vpc_config[_]
	count(vpc.subnet_ids) > 0
}