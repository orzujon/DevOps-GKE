terraform {
  backend "gcs" {
    bucket = "tfstate-prj-aorzu-dev-platform"
    prefix = "dev"
  }
}