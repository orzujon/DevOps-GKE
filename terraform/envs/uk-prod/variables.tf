variable "project_id" {
  type        = string
}

variable "cluster_name" {
  type    = string
  default = "uk-gcp-prod-gke"
}

variable "environment" {
  type    = string
  default = "prod"
}