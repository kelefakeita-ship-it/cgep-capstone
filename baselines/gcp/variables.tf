# variables.tf
variable "gcp_project" {
  type        = string
  description = "GCP project ID."
  default     = "my-gcp-project-496817"
}

variable "gcp_region" {
  type        = string
  description = "GCP region."
  default     = "europe-west6"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository allowed to use Workload Identity Federation."
  default     = "kelefakeita-ship-it/cgep-capstone"
}

variable "enable_org_policies" {
  type        = bool
  description = "Whether to deploy Org Policy resources. Requires the project to belong to a GCP Organization (Cloud Identity or Google Workspace). Personal/standalone projects under 'No Organization' cannot create org policies regardless of IAM role."
  default     = false
}