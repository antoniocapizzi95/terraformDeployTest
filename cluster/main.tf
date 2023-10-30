# Get Azure provider to create the cluster
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "testK8sGroup"     # Name of the resource group
  location = "northeurope"      # Location where the resource group will be created
}

# Create a Kubernetes cluster
resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "test-k8s-cluster"                    # Name of the Kubernetes cluster
  location            = azurerm_resource_group.rg.location  # Location same as the resource group
  resource_group_name = azurerm_resource_group.rg.name      # Resource group associated with the cluster
  dns_prefix          = "test-k8s-cluster"                    # Prefix used for DNS resolution

  default_node_pool {
    name       = "default"           # Name of the default node pool
    node_count = "1"                 # Number of nodes in the node pool
    vm_size    = "standard_d2_v2"    # Virtual machine size for the nodes
  }

  identity {
    type = "SystemAssigned"  # Enable system-assigned managed identity for the cluster
  }
}