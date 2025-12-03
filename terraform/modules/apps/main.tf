resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "app_a" {
  name      = "app-a"
  namespace = kubernetes_namespace.app.metadata[0].name
  chart     = "${var.charts_root}/app-a"
  values    = [file("${var.charts_root}/app-a/values.yaml")]

  depends_on = [
    kubernetes_namespace.app
  ]
}

resource "helm_release" "app_b" {
  name      = "app-b"
  namespace = kubernetes_namespace.app.metadata[0].name
  chart     = "${var.charts_root}/app-b"
  values    = [file("${var.charts_root}/app-b/values.yaml")]

  depends_on = [
    kubernetes_namespace.app
  ]
}
