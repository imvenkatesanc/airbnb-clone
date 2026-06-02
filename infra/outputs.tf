# ─────────────────────────────────────────────────────────────────
# Outputs — printed after terraform apply
# ─────────────────────────────────────────────────────────────────

output "acr_login_server" {
  description = "ACR login server URL"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "ACR admin username"
  value       = azurerm_container_registry.acr.admin_username
}

output "backend_url" {
  description = "Backend App Service URL"
  value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
}

output "frontend_url" {
  description = "Frontend App Service URL"
  value       = "https://${azurerm_linux_web_app.frontend.default_hostname}"
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.rg.name
}
