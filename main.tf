provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "devops-catalog-aks"
    storage_account_name = "devopscatalog"
    container_name       = "devopscatalog"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_kubernetes_cluster" "primary" {
  count               = var.destroy == true ? 0 : 1
  name                = var.cluster_name
  location            = var.region
  resource_group_name = var.resource_group
  dns_prefix          = var.dns_prefix
  default_node_pool {
    name                = var.cluster_name
    vm_size             = var.machine_type
    enable_auto_scaling = true
    max_count           = var.max_node_count
    min_count           = var.min_node_count
  }
  identity {
    type = "SystemAssigned"
  }
}
