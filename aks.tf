#create random generator
resource "random_id" "log_analitics" {
  byte_length = 8
}

#Create loganalytics workspace
resource "azurerm_log_analytics_workspace" "k8s" {
  name                = "${var.loganalytics_workspace_name}-${random_id.log_analitics.dec}"
  location            = var.loganalytics_workspace_location
  resource_group_name = azurerm_resource_group.tfstate.name
  sku                 = var.loganalytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "k8s" {
  solution_name         = "ContainerInsights"
  resource_group_name   = azurerm_resource_group.tfstate.name
  location              = azurerm_log_analytics_workspace.k8s.location
  workspace_resource_id = azurerm_log_analytics_workspace.k8s.id
  workspace_name        = azurerm_log_analytics_workspace.k8s.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

}


#Create AKS cluster
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_log_analytics_workspace.k8s.location
  dns_prefix          = var.dns_prefix
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  default_node_pool {
    name       = "agentpool"
    node_count = var.agent_count
    vm_size    = "Standard_D2s_v3"
  }
  service_principal {
    client_id     = var.aks_service_principal_app_id
    client_secret = var.aks_service_principal_client_secret
  }

#Setup monitoring
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.k8s.id
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = {
    environment = "Staging"
  }
}
