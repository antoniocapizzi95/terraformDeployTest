# Connecting to the Kubernetes cluster to run a pod and a service related to it
provider "kubernetes" {
  config_path = var.k8s_config_path
}

# Creating the service to expose the pod on the internal network
resource "kubernetes_service" "microservice1_service" {
  metadata {
    name      = var.service_name
    namespace = var.service_namespace
  }

  spec {
    selector = {
      app = var.deployment_name  # Select pods with the label "app=microservice1"
    }

    port {
      protocol   = "TCP"  # Protocol of the port
      port       = var.service_port
    }

    type = "ClusterIP"  # Type of the service
  }
}

# Deploying a pod using a Docker image containing the microservice
resource "kubernetes_deployment" "microservice1_deployment" {
  metadata {
    name      = var.deployment_name
    namespace = var.deployment_namespace

    labels = {
      app = var.deployment_name  # Deployment label
    }
  }

  spec {
    replicas = 1  # Number of pods to create

    selector {
      match_labels = {
        app = var.deployment_name  # Match pods with the label "app=microservice1"
      }
    }

    template {
      metadata {
        labels = {
          app = var.deployment_name  # Label for the pod
        }
      }

      spec {
        container {
          name            = var.container_name
          image           = var.container_image
          image_pull_policy = "Always"
          port {
            container_port  = var.service_port
          }
        }
      }
    }
  }
}
