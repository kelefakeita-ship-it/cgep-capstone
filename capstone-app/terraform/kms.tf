######################################################################
# KMS — Customer-managed key for PHI data at rest.
# Brings the starter's S3 uploads bucket and DynamoDB table under
# customer custody (closes GAP-01 and GAP-02).
# SOC 2 CC6.1 — logical access security measures protect data at rest.
######################################################################

resource "aws_kms_key" "phi" {
  description             = "CMK for Acme Health Patient Intake PHI data (S3 uploads + DynamoDB submissions)"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "phi" {
  name          = "alias/acme-health-intake-phi"
  target_key_id = aws_kms_key.phi.key_id
}