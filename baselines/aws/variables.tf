# variables.tf
variable "aws_region" {
  type        = string
  description = "AWS region for the baseline services."
  default     = "us-east-1"
}