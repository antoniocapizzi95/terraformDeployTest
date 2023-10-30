variable "k8s_config_path" {
  default = "~/.kube/config"
}

variable "ingress_name" {
  default = "main-ingress"
}

variable "ingress_controller_class" {
  default = "nginx"
}

variable "backend_service_name" {
  default = "microservice1-service"
}

variable "backend_service_port" {
  default = 8080
}