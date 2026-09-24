output "resource_group_name" {
  value = azurerm_resource_group.polyauth.name
}

output "web_app_name" {
  value = azurerm_linux_web_app.polyauth.name
}

output "web_app_default_hostname" {
  value = azurerm_linux_web_app.polyauth.default_hostname
}

output "container_registry_login_server" {
  value = azurerm_container_registry.polyauth.login_server
}

output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.polyauth.fqdn
}
