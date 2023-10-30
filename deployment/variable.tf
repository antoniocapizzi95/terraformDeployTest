# Declaration of variables
variable "k8s_config_path" {
  type    = string
  default = "~/.kube/config"  # Path to the Kubernetes configuration file
}

variable "service_name" {
  type    = string
  default = "microservice1-service"  # Name of the service
}

variable "service_namespace" {
  type    = string
  default = "default"  # Namespace where the service will be deployed
}

variable "service_port" {
  type    = number
  default = 8080  # Port number
}

variable "deployment_name" {
  type    = string
  default = "microservice1"  # Name of the deployment
}

variable "deployment_namespace" {
  type    = string
  default = "default"  # Namespace where the deployment will be created
}

variable "container_name" {
  type    = string
  default = "microservice1-container"  # Name of the container
}

variable "container_image" {
  type    = string
  default = "antoniocapizzi95/terraform-deploy-test:latest"  # Docker image to use
}