terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}


data "google_client_config" "default" {}

provider "kubernetes" {
  host = "https://${google_container_cluster.uk_gke.endpoint}"

  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    google_container_cluster.uk_gke.master_auth[0].cluster_ca_certificate
  )
  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*",
  ]
}

provider "helm" {
  kubernetes {
    host = "https://${google_container_cluster.uk_gke.endpoint}"

    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      google_container_cluster.uk_gke.master_auth[0].cluster_ca_certificate
    )
  }
}