# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app

resource "azurerm_resource_group" "Portfolio" {
  name     = var.rg_name
  location = var.azure_location
}

resource "azurerm_service_plan" "AppServicePlan" {
  name                = "AppServicePlan"
  resource_group_name = azurerm_resource_group.Portfolio.name
  location            = azurerm_resource_group.Portfolio.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "WebApp" {
  name                = var.webapp_name
  resource_group_name = azurerm_resource_group.Portfolio.name
  location            = azurerm_service_plan.AppServicePlan.location
  service_plan_id     = azurerm_service_plan.AppServicePlan.id
  https_only = true
  site_config {}
}
