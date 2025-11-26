variable "project_id" {
  type        = string
  description = "GCP project ID"
  default     = "gke-dev-project-001"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "cluster_name" {
  type    = string
  default = "autopilot-cluster-1"
}

variable "release_name" {
  default = "hello-dev"
}

variable "environment" {
  type    = string
  default = "dev"
}

