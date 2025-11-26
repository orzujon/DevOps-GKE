variable "project_id" {
  type        = string
  description = "GCP project ID"
  default     = "uat-env-gke"
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
  default = "hello-uat"
}

variable "environment" {
  type    = string
  default = "uat"
}

