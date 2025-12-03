moved {
  from = google_container_cluster.dev
  to   = module.cluster.google_container_cluster.this
}

moved {
  from = kubernetes_namespace.app
  to   = module.apps.kubernetes_namespace.app
}

moved {
  from = helm_release.app_a
  to   = module.apps.helm_release.app_a
}

moved {
  from = helm_release.app_b
  to   = module.apps.helm_release.app_b
}

moved {
  from = kubernetes_namespace.cert_manager
  to   = module.cert_manager.kubernetes_namespace.cert_manager
}

moved {
  from = helm_release.cert_manager
  to   = module.cert_manager.helm_release.cert_manager
}

moved {
  from = google_project_service.compute
  to   = module.cluster.google_project_service.compute
}

moved {
  from = google_project_service.iam
  to   = module.cluster.google_project_service.iam
}

moved {
  from = google_project_service.serviceusage
  to   = module.cluster.google_project_service.serviceusage
}