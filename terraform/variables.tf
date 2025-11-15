variable "project_id" {}
variable "region" {}
variable "cluster_name" {}
variable "namespace" {
  default = "app-dev"
}
variable "release_name" {
  default = "hello-dev"
}
