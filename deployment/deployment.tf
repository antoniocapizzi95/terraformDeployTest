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

    type = "ClusterIP"
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
