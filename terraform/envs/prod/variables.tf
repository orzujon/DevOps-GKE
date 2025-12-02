variable "project_id" {
  type        = string
  description = "GCP project ID"
  default     = "prj-aorzu-dev-platform"
}

variable "zone" {
  type    = string
  default = "europe-west2-b"
}

variable "region" {
  type    = string
  default = "europe-west2"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "cluster_name" {
  type    = string
  default = "ukaorzd1"
}