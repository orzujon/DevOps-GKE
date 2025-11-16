resource "helm_release" "web" {
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true

  # 👇 LOCAL chart, from your repo
  chart = "${path.module}/charts/hello"

  # 👇 Extra override values (optional)
  values = [
    file("${path.module}/values/web.yaml")
  ]
}

resource "helm_release" "wi_debug" {
  name             = "wi-debug"
  namespace        = "app-dev"
  create_namespace = true

  chart  = "${path.module}/charts/wi-debug"
  values = [file("${path.module}/values/wi-debug.yaml")]
}