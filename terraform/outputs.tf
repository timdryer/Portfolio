output "webapp_https_url" {
  description = "Full HTTPS URL of the Web App"
  value       = "https://${azurerm_linux_web_app.WebApp.default_hostname}"
}
output "resource_group_name" {
  value = azurerm_resource_group.Portfolio.name
}

output "service_plan_id" {
  value = azurerm_service_plan.AppServicePlan.id
}