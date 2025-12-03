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
resource "google_container_cluster" "this" {
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