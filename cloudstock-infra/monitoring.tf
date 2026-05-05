# 1. Membuat Log Analytics Workspace (Gudang Log Terpusat)
resource "azurerm_log_analytics_workspace" "cloudstock_law" {
  name                = "law-cloudstock-asia-777"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  
  # Optimasi Biaya: Kita batasi penyimpanan log hanya 30 hari
  retention_in_days   = 30 
}

# 2. Membuat Application Insights (Pemantau Performa API)
resource "azurerm_application_insights" "cloudstock_appinsights" {
  name                = "appi-cloudstock-asia-777"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.cloudstock_law.id
  application_type    = "web"
}