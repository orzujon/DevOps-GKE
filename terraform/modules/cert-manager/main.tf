resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = kubernetes_namespace.cert_manager.metadata[0].name

  chart  = "${var.charts_root}/cert-manager"
  values = [file("${var.charts_root}/cert-manager/values-dev.yaml")]

  wait    = true
  timeout = 600

  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}