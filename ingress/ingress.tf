# Add Helm Provider to install Nginx Ingress
provider "helm" {
  kubernetes {
    config_path = var.k8s_config_path # Specifies the location of the kubeconfig file
  }
}

# Install Nginx Ingress
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller" # Specifies the name of the Helm release

  repository = "https://charts.bitnami.com/bitnami"    # Specifies the repository URL
  chart      = "nginx-ingress-controller"              # Specifies the chart to be installed

  set {
    name  = "service.type" # Sets the value of the "service.type" parameter
    value = "LoadBalancer" # Specifies the type of service to be created
  }
  set {
    name  = "controller.ingressClass" # Sets the value of the "controller.ingressClass" parameter
    value = "nginx"                   # Specifies the class of the nginx ingress controller
  }
}

provider "kubernetes" {
  config_path = var.k8s_config_path
}
# Define Ingress to expose pods
resource "kubernetes_ingress_v1" "main_ingress" {
  metadata {
    name = var.ingress_name # Specifies the name of the ingress resource
    annotations = {
      "kubernetes.io/ingress.class" = var.ingress_controller_class # Specifies the class of the ingress controller to be used
    }
  }

  spec {
    default_backend {
      service {
        name = var.backend_service_name # Specifies the name of the backend service
        port {
          number = var.backend_service_port # Specifies the port number of the backend service
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = var.backend_service_name # Specifies the name of the backend service for this rule
              port {
                number = var.backend_service_port # Specifies the port number of the backend service for this rule
              }
            }
          }

          path = "/" # Specifies the path for this rule
        }
      }
    }
  }
}