provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "controller.ingressClass"
    value = "nginx"
  }
}

resource "kubernetes_ingress_v1" "main_ingress" {
  metadata {
    name = "main-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    default_backend {
      service {
        name = "microservice1-service"
        port {
          number = 8080
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = "microservice1-service"
              port {
                number = 8080
              }
            }
          }

          path = "/"
        }
      }
    }
  }
}