provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_service" "microservice1_service" {
  metadata {
    name      = "microservice1-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "microservice1"
    }

    port {
      protocol   = "TCP"
      port       = 8080
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "microservice1_deployment" {
  metadata {
    name      = "microservice1"
    namespace = "default"

    labels = {
      app = "microservice1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "microservice1"
      }
    }

    template {
      metadata {
        labels = {
          app = "microservice1"
        }
      }

      spec {
        container {
          name            = "microservice1-container"
          image           = "antoniocapizzi95/terraform-deploy-test:latest"
          image_pull_policy = "Always"
          port {
            container_port  = 8080
          }
        }
      }
    }
  }
}

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
