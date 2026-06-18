# outputs.tf
output "workload_identity_provider" {
  value       = "projects/${var.gcp_project}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.github.workload_identity_pool_provider_id}"
  description = "WIF provider resource name for use in GitHub Actions workflows."
}

output "service_account_email" {
  value       = google_service_account.gha.email
  description = "Service account email for GitHub Actions."
}

output "wif_pool_name" {
  value       = google_iam_workload_identity_pool.github.name
  description = "Full WIF pool resource name."
}