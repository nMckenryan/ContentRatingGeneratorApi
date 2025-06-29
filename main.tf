terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "api_rg" {
  name     = "rg-myapi-prod"
  location = "Australia Southeast"
}

# App Service Plan
resource "azurerm_service_plan" "api_plan" {
  name                = "plan-myapi-prod"
  resource_group_name = azurerm_resource_group.api_rg.name
  location            = azurerm_resource_group.api_rg.location
  os_type             = "Windows"
  sku_name            = "B1"
}

# App Service
resource "azurerm_windows_web_app" "api_app" {
  name                = "app-myapi-prod"
  resource_group_name = azurerm_resource_group.api_rg.name
  location            = azurerm_service_plan.api_plan.location
  service_plan_id     = azurerm_service_plan.api_plan.id

  site_config {
    default_documents = ["Default.htm", "Default.html", "index.html"]
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}