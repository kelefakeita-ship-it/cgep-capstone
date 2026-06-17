# main.tf
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project         = "cgep-lab"
      Environment     = "baseline"
      ManagedBy       = "terraform"
      ComplianceScope = "cge-p-lab"
    }
  }
}

# Used to build globally-unique S3 bucket names for the trail logs.
resource "random_id" "suffix" {
  byte_length = 4
}

# Provides the AWS account ID for CloudTrail bucket policy conditions.
data "aws_caller_identity" "current" {}