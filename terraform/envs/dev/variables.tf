variable "project_id" {
  type    = string
  default = "prj-aorzu-dev-platform"
}

variable "region" {
  type    = string
  default = "europe-west2"
}

variable "zone" {
  type    = string
  default = "europe-west2-b"
}

variable "cluster_name" {
  type    = string
  default = "ukaorzd1"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}