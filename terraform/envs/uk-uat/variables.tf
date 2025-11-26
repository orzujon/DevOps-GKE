variable "project_id" {
  type        = string
}

variable "cluster_name" {
  type    = string
  default = "uk-gcp-uat-gke"
}

variable "environment" {
  type    = string
  default = "uat"
}