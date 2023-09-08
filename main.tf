provider "azurerm" {
    subscription_id = "63624c86-fe10-49d1-b0c7-b5b0be84da6a"
    client_id = "27ed852a-f10d-41bc-951c-d12bca932c28"
    client_secret = "Wvi8Q~13MgHl609Cm6Ba6F-774N3uUnk5dECGb0F"
    tenant_id = "7270ce39-4b64-4579-8f7f-93639d71f1ca"

    features {
      
    }
  
}
resource "azurerm_resource_group" "adi-t2" {
    name = var.resource_group_name
    location = var.location
  
}

resource "azurerm_container_registry" "acr" {
  name                = "kubernetedcontainer"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
  depends_on = [ azurerm_resource_group.adi-t2 ]
  
}
resource "azurerm_container_registry_scope_map" "Scope_map" {
  name                    = "kuberScMap"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = var.resource_group_name
  actions = [
    "repositories/repo1/content/read",
    "repositories/repo1/content/write"
  ]
}
resource "azurerm_container_registry_token" "Token" {
  name                    = "KuberToken"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = var.resource_group_name
 scope_map_id = azurerm_container_registry_scope_map.Scope_map.id
  
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "Kube-p2"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
  depends_on = [ azurerm_resource_group.adi-t2 ]
}