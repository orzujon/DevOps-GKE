############################################
# 0. Cluster
############################################

resource "google_container_cluster" "uk_gke" {
  name                = "uk-gcp-dev-gke"
  location            = "europe-west2"
  enable_autopilot    = true
  deletion_protection = false
}

############################################
# 1. Namespace (per environment)
############################################

resource "kubernetes_namespace" "app" {
  metadata {
    name = "app-${var.environment}"
  }
}

############################################
# 2. Kubernetes Service Account (KSA)
############################################

resource "kubernetes_service_account" "app" {
  metadata {
    name      = "app-${var.environment}-ksa"
    namespace = kubernetes_namespace.app.metadata[0].name

    annotations = {
      # This will be filled once the GSA exists – see note below
      "iam.gke.io/gcp-service-account" = google_service_account.app.email
    }
  }
}

############################################
# 3. Google Service Account (GSA)
############################################

resource "google_service_account" "app" {
  account_id   = "app-${var.environment}-gsa"
  display_name = "App ${var.environment} GSA"
}

# Example: give the app GSA some permissions (adjust to your needs)
# e.g. read from a bucket, BigQuery, etc.
resource "google_project_iam_member" "app_gcs_reader" {
  project = var.project_id
  role    = "roles/storage.objectViewer"

  member = "serviceAccount:${google_service_account.app.email}"
}

############################################
# 4. Workload Identity binding (KSA ↔ GSA)
############################################

# Allow the KSA identity to impersonate the GSA via Workload Identity
resource "google_service_account_iam_member" "app_wi_binding" {
  service_account_id = google_service_account.app.name
  role               = "roles/iam.workloadIdentityUser"

  # KSA identity in GKE:
  # serviceAccount:<PROJECT_ID>.svc.id.goog[<namespace>/<ksa-name>]
  member = "serviceAccount:${var.project_id}.svc.id.goog[${kubernetes_namespace.app.metadata[0].name}/${kubernetes_service_account.app.metadata[0].name}]"
}

############################################
# 5. Helm release using that KSA
############################################

#  resource "helm_release" "web" {
#  name      = "web-${var.environment}"
#  namespace = kubernetes_namespace.app.metadata[0].name
#  chart     = "${path.module}/../../charts/hello" # adjust to your chart path
#
#  # Ensure the chart uses our existing KSA and does not create its own.
#  # This assumes your chart supports "serviceAccount.create" and "serviceAccount.name".
#  # If not, you'll tweak your chart or values accordingly.
#
#  set {
#    name  = "serviceAccount.create"
#    value = "false"
#  }
#
#  set {
#    name  = "serviceAccount.name"
#    value = kubernetes_service_account.app.metadata[0].name
#  }
#
#  # Add other values/overrides as you already had:
#  # set {
#  #   name  = "replicaCount"
#  #   value = "1"
#  # }
#  }