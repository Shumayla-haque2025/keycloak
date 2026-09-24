variable "location" {
  description = "Azure region"
  type        = string
  default     = "Canada Central"
}

variable "resource_group_name" {
  description = "Azure resource group"
  type        = string
  default     = "rg-polyauth"
}

variable "app_service_plan_name" {
  description = "App Service Plan"
  type        = string
  default     = "asp-polyauth"
}

variable "web_app_name" {
  description = "Azure Web App name"
  type        = string
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
}

variable "postgres_server_name" {
  description = "PostgreSQL server name"
  type        = string
}

variable "postgres_admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
  default     = "keycloakadmin"
}

variable "postgres_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}

variable "keycloak_hostname" {
  description = "Public Keycloak URL"
  type        = string
  default     = "https://polyauth.ixmedia.ai"
}

variable "keycloak_admin_password" {
  description = "Keycloak administrator password"
  type        = string
  sensitive   = true
}
