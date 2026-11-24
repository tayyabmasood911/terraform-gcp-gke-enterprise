# ==============================================================================
# Google Cloud Workload Identity Federation Mapping
# ==============================================================================

resource "google_service_account" "app_workload" {
  account_id   = "sa-gke-app-production"
  display_name = "GKE Workload Identity Application Service Account"
}

# Allow Kubernetes ServiceAccount 'default:app-service-account' to impersonate Google SA
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.app_workload.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/app-service-account]"
  ]
}

# Example IAM Role: Secret Manager Secret Accessor
resource "google_project_iam_member" "app_secret_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.app_workload.email}"
}
