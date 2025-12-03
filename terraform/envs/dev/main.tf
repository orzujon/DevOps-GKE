module "cluster" {
  source       = "../../modules/cluster"
  project_id   = var.project_id
  region       = var.region
  zone         = var.zone
  cluster_name = var.cluster_name
  environment  = var.environment
}

module "cert_manager" {
  source      = "../../modules/cert-manager"
  namespace   = "cert-manager"
  charts_root = "${path.root}/../../charts"

  depends_on = [module.cluster]
}

module "istio" {
  source      = "../../modules/istio"
  namespace   = "istio-system"
  charts_root = "${path.root}/../../charts/istio"
  

  depends_on = [module.cluster]
}

module "apps" {
  source      = "../../modules/apps"
  namespace   = "app-dev"
  charts_root = "${path.root}/../../charts"


  depends_on = [
    module.cluster,
    module.istio, # if apps should only start after mesh
  ]
}