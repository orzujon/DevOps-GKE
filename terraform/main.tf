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
