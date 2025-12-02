########################################
# Enable required APIs
########################################
resource "google_project_service" "container" {
  service = "container.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "serviceusage" {
  service = "serviceusage.googleapis.com"
  project = var.project_id
}

########################################
# Standard GKE dev cluster
########################################
resource "google_container_cluster" "dev" {
  name     = var.cluster_name
  location = var.zone
  project  = var.project_id

  remove_default_node_pool = false
  initial_node_count       = 2

  networking_mode = "VPC_NATIVE"

  node_config {
    machine_type = "e2-standard-4"
    disk_size_gb = 50
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  depends_on = [
    google_project_service.container,
    google_project_service.compute,
    google_project_service.iam,
    google_project_service.serviceusage,
  ]
}

############################################
# 6. Cert Manager Namespace
############################################
resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

############################################
# 7. Cert Manager Helm release
############################################

resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  namespace = "cert-manager"

  chart = "${path.module}/../../charts/cert-manager"

  values = [
    file("${path.module}/../../charts/cert-manager/values-dev.yaml")
  ]
  wait    = false
  timeout = 600
}

############################################
# 8. App-b
############################################

resource "helm_release" "app_b" {
  name      = "app-b"
  namespace = "app-dev"

  chart = "${path.module}/../../charts/app-b"
}


############################################
# 8. App-a
############################################

resource "helm_release" "app_a" {
  name      = "app-a"
  namespace = "app-dev"

  chart = "${path.module}/../../charts/app-a"
}

##########################################
# Istio Namespace
##########################################
resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

##########################################
# Istio Base (CRDs)
##########################################
resource "helm_release" "istio_base" {
  name      = "istio-base"
  namespace = kubernetes_namespace.istio_system.metadata[0].name

  chart = "${path.module}/../../charts/istio/base"

  depends_on = [
    kubernetes_namespace.istio_system
  ]
}

##########################################
# Istio Control Plane (istiod)
##########################################
resource "helm_release" "istiod" {
  name      = "istiod"
  namespace = kubernetes_namespace.istio_system.metadata[0].name

  chart = "${path.module}/../../charts/istio/istiod"

  depends_on = [
    helm_release.istio_base
  ]
}

##########################################
# Istio Ingress Gateway
##########################################
resource "helm_release" "istio_ingressgateway" {
  name      = "istio-ingressgateway"
  namespace = kubernetes_namespace.istio_system.metadata[0].name

  chart = "${path.module}/../../charts/istio/gateway"

  values = [
    file("${path.module}/../../charts/gateway/values-dev.yaml")
  ]

  depends_on = [
    helm_release.istiod
  ]
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