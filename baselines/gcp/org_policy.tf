# org_policy.tf
#
# NOTE: These resources require the project to belong to a GCP Organization.
# Personal/standalone GCP projects under "No Organization" cannot create
# org policies via the Organization Policy Service v2 API, even with the
# Owner IAM role. This is a structural GCP limitation, not a permissions
# bug. Setting var.enable_org_policies = true will only work if this
# project is migrated under a Cloud Identity or Google Workspace
# Organization. See README.md for details.

# Enforce uniform bucket-level access — no ACLs allowed (CM-6)
resource "google_org_policy_policy" "uniform_bucket_access" {
  count  = var.enable_org_policies ? 1 : 0
  name   = "projects/${var.gcp_project}/policies/storage.uniformBucketLevelAccess"
  parent = "projects/${var.gcp_project}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

# Prevent creation of long-lived service account keys (AC-2)
resource "google_org_policy_policy" "disable_sa_keys" {
  count  = var.enable_org_policies ? 1 : 0
  name   = "projects/${var.gcp_project}/policies/iam.disableServiceAccountKeyCreation"
  parent = "projects/${var.gcp_project}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

# Require OS Login for SSH access to compute instances (AC-3)
resource "google_org_policy_policy" "require_oslogin" {
  count  = var.enable_org_policies ? 1 : 0
  name   = "projects/${var.gcp_project}/policies/compute.requireOsLogin"
  parent = "projects/${var.gcp_project}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}