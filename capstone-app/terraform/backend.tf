######################################################################
# Remote state backend.
# State lives in a versioned, encrypted S3 bucket with DynamoDB-based
# locking instead of on a developer laptop. This is itself a control:
# - versioning      -> state history / rollback
# - encryption      -> infrastructure details protected at rest
# - DynamoDB lock   -> no concurrent-apply state corruption
# - off the laptop  -> CI/CD and humans share one source of truth
######################################################################

terraform {
  backend "s3" {
    bucket         = "cgep-capstone-tfstate-254053128942"
    key            = "capstone/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cgep-capstone-tflock"
    encrypt        = true
  }
}