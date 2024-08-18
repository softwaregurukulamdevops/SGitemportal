provider "azurerm" {
  features {}
}

# Define the Resource Group
resource "azurerm_resource_group" "example" {
  name     = "rg-itemportal-resources"
  location = "East US"  # Replace with your desired location
}

# Define the Standard App Service Plan
resource "azurerm_app_service_plan" "standard_plan" {
  name                = "rg-itemportal-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "App"
  
  sku {
    tier = "Standard"
    size = "S1"  # Adjust size according to your needs
  }
}

# Define the Linux App Service Plan for Containers
resource "azurerm_service_plan" "linux_plan" {
  name                = "rg-itemportal-linux-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"
  reserved            = true  # Required for Linux-based App Service Plan
  
  sku {
    tier = "Basic"
    size = "B1"  # Adjust size according to your needs
  }
}

# Define the Standard App Service
resource "azurerm_app_service" "standard_service" {
  name                = "rg-itemportal-standard-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.standard_plan.id

}

# Define the Container-based App Service
resource "azurerm_app_service" "container_service" {
  name                = "rg-itemportal-container-app"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_service_plan.linux_plan.id
  
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"  # Optional: Disable persistent storage if not needed
    "SOME_SETTING"                        = "value"
  }
}

# Output the URLs
output "standard_app_service_default_hostname" {
  value = azurerm_app_service.standard_service.default_site_hostname
}

output "container_app_service_default_hostname" {
  value = azurerm_app_service.container_service.default_site_hostname
}
