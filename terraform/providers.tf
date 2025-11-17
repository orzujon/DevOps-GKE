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

  impersonate_service_account = "terraform-deployer@lithe-bonito-477114-a8.iam.gserviceaccount.com"
}

provider "kubernetes" {
  host  = data.google_container_cluster.cluster.endpoint
  token = data.google_container_cluster.cluster.access_token

  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = data.google_container_cluster.cluster.endpoint
    token = data.google_container_cluster.cluster.access_token

    cluster_ca_certificate = base64decode(
      data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
    )
  }
}