resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "istio_base" {
  name      = "istio-base"
  namespace = kubernetes_namespace.istio_system.metadata[0].name
  chart     = "${var.charts_root}/base"

  depends_on = [kubernetes_namespace.istio_system]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  namespace  = kubernetes_namespace.istio_system.metadata[0].name
  chart      = "${var.charts_root}/istiod"
  values     = [file("${var.charts_root}/istiod/values.yaml")]

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "ingressgateway" {
  name      = "istio-ingressgateway"
  namespace = kubernetes_namespace.istio_system.metadata[0].name
  chart     = "${var.charts_root}/gateway"
  values    = [file("${var.charts_root}/gateway/values.yaml")]

  depends_on = [helm_release.istiod]
}