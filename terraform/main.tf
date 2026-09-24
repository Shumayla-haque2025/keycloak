resource "azurerm_resource_group" "polyauth" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "polyauth" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.polyauth.name
  location            = azurerm_resource_group.polyauth.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_service_plan" "polyauth" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.polyauth.name
  location            = azurerm_resource_group.polyauth.location

  os_type  = "Linux"
  sku_name = "B1"
}

resource "azurerm_postgresql_flexible_server" "polyauth" {
  name                = var.postgres_server_name
  resource_group_name = azurerm_resource_group.polyauth.name
  location            = azurerm_resource_group.polyauth.location

  version = "16"

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  storage_mb = 32768
  sku_name   = "B_Standard_B1ms"

  backup_retention_days = 7
}

resource "azurerm_postgresql_flexible_server_database" "keycloak" {
  name      = "keycloak"
  server_id = azurerm_postgresql_flexible_server.polyauth.id

  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_linux_web_app" "polyauth" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.polyauth.name
  location            = azurerm_resource_group.polyauth.location
  service_plan_id     = azurerm_service_plan.polyauth.id

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true

    minimum_tls_version = "1.2"

    application_stack {
      docker_image_name = "keycloak/keycloak:latest"
    }

    health_check_path = "/health/ready"
  }

  app_settings = {
    WEBSITES_PORT = "8080"

    KC_DB = "postgres"

    KC_DB_URL = "jdbc:postgresql://${azurerm_postgresql_flexible_server.polyauth.fqdn}:5432/keycloak"

    KC_DB_USERNAME = var.postgres_admin_username

    KC_DB_PASSWORD = var.postgres_admin_password

    KC_HOSTNAME = var.keycloak_hostname

    KC_PROXY_HEADERS = "xforwarded"

    KC_HTTP_ENABLED = "true"

    KC_HEALTH_ENABLED = "true"

    KC_METRICS_ENABLED = "true"

    KEYCLOAK_ADMIN = "admin"

    KEYCLOAK_ADMIN_PASSWORD = var.keycloak_admin_password
  }
}
