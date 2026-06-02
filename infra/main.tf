# ─────────────────────────────────────────────────────────────────
# Provider
# ─────────────────────────────────────────────────────────────────
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

# ─────────────────────────────────────────────────────────────────
# Resource Group
# ─────────────────────────────────────────────────────────────────
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# ─────────────────────────────────────────────────────────────────
# Azure Container Registry (ACR)
# ─────────────────────────────────────────────────────────────────
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# ─────────────────────────────────────────────────────────────────
# App Service Plan (B1 — supports Docker containers)
# ─────────────────────────────────────────────────────────────────
resource "azurerm_service_plan" "plan" {
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# ─────────────────────────────────────────────────────────────────
# Backend App Service
# ─────────────────────────────────────────────────────────────────
resource "azurerm_linux_web_app" "backend" {
  name                = "${var.app_name}-backend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      docker_image_name        = "airbnb-backend:latest"
      docker_registry_url      = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = azurerm_container_registry.acr.admin_username
      docker_registry_password = azurerm_container_registry.acr.admin_password
    }
    always_on = true
  }

  app_settings = {
    NODE_ENV                        = "production"
    PORT                            = "4000"
    DB_URL                          = var.db_url
    JWT_SECRET                      = var.jwt_secret
    JWT_EXPIRY                      = var.jwt_expiry
    COOKIE_TIME                     = var.cookie_time
    SESSION_SECRET                  = var.session_secret
    CLOUDINARY_NAME                 = var.cloudinary_name
    CLOUDINARY_API_KEY              = var.cloudinary_api_key
    CLOUDINARY_API_SECRET           = var.cloudinary_api_secret
    CLIENT_URL                      = "https://${var.app_name}-frontend.azurewebsites.net"
    WEBSITES_PORT                   = "4000"
    DOCKER_REGISTRY_SERVER_URL      = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
  }
}

# ─────────────────────────────────────────────────────────────────
# Frontend App Service
# ─────────────────────────────────────────────────────────────────
resource "azurerm_linux_web_app" "frontend" {
  name                = "${var.app_name}-frontend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      docker_image_name        = "airbnb-frontend:latest"
      docker_registry_url      = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = azurerm_container_registry.acr.admin_username
      docker_registry_password = azurerm_container_registry.acr.admin_password
    }
    always_on = true
  }

  app_settings = {
    WEBSITES_PORT                   = "80"
    DOCKER_REGISTRY_SERVER_URL      = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
  }
}
