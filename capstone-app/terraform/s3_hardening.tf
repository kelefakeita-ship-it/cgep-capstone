######################################################################
# S3 hardening overrides for the uploads bucket.
# Closes GAP-01 (CMK encryption), GAP-03 (TLS enforcement),
# GAP-04 (versioning).
######################################################################

# GAP-01: SSE-KMS with the customer CMK instead of AWS-managed SSE-S3.
# SOC 2 CC6.1 — encryption protects data at rest under customer custody.
resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.phi.arn
    }
    bucket_key_enabled = true
  }
}

# GAP-04: versioning so PHI overwrites are recoverable.
# SOC 2 A1.2 — availability commitments, environmental protections.
resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  versioning_configuration {
    status = "Enabled"
  }
}

# GAP-03: deny any request that does not use TLS.
# SOC 2 CC6.7 — transmission of data is protected.
data "aws_iam_policy_document" "uploads_tls_only" {
  statement {
    sid       = "DenyInsecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "uploads_tls_only" {
  bucket = aws_s3_bucket.uploads.id
  policy = data.aws_iam_policy_document.uploads_tls_only.json
}
