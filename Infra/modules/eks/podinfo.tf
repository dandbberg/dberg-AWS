# infra/podinfo.tf
resource "kubernetes_namespace" "podinfo" {
  metadata {
    name = "podinfo"
  }
}
resource "helm_release" "podinfo" {
  name       = "podinfo"
  namespace  = "podinfo"
  repository = "https://stefanprodan.github.io/podinfo"
  chart      = "podinfo"
  version    = "6.9.1"
  values = [
    yamlencode({
      replicaCount = 2
      service = {
        type = "ClusterIP"
        port = 9898
      }
    })
  ]
}


# Optional: Add ingress rule for podinfo
resource "kubernetes_ingress_v1" "podinfo_ingress" {
  metadata {
    name      = "podinfo-ingress"
    namespace = "podinfo"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
    }
  }
  spec {
    rule {
      http {
        path {
          path     = "/podinfo"
          path_type = "Prefix"
          backend {
            service {
              name = helm_release.podinfo.name
              port {
                number = 9898
              }
            }
          }
        }
      }
    }
  }
}
