provider "azurerm" {
  features {}
}

# Define the Resource Group
resource "azurerm_resource_group" "example" {
  name     = "rg-itemportal-container-resources"
  location = "East US"  # Replace with your desired location
}

# Define the Linux App Service Plan for Containers
resource "azurerm_app_service_plan" "linux_plan" {
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

# Define the Container-based App Service
resource "azurerm_app_service" "container_service" {
  name                = "rg-itemportal-container-app"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.linux_plan.id

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"  # Optional: Disable persistent storage if not needed
    "SOME_SETTING"                        = "value"
  }
}

# Output the URL
output "container_app_service_default_hostname" {
  value = azurerm_app_service.container_service.default_site_hostname
}
