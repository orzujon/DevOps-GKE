variable "project_id" {
  type = string
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "cluster_name" {
  type = string
  default = "autopilot-cluster-1"
} 
 
variable "namespace" {
  default = "app-dev"
}
variable "release_name" {
  default = "hello-dev"
}
