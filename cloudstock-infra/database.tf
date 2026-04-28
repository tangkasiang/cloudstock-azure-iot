# Mengambil data konfigurasi Azure saat ini
data "azurerm_client_config" "current" {}

# 1. Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = "kv-cloudstock-asia-777"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
}

# Memberikan akses Admin ke Key Vault
resource "azurerm_key_vault_access_policy" "admin_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]
}

# 2. Azure Table Storage (Pengganti Cosmos DB)
resource "azurerm_storage_table" "table" {
  name                 = "StockDataTable"
  storage_account_name = azurerm_storage_account.sa.name
}

# 3. Merekam Connection String
resource "azurerm_key_vault_secret" "db_conn" {
  name         = "StorageConnectionString"
  value        = azurerm_storage_account.sa.primary_connection_string
  key_vault_id = azurerm_key_vault.kv.id
  
  depends_on = [
    azurerm_key_vault.kv,
    azurerm_key_vault_access_policy.admin_policy
  ]
}

# 4. Storage Container (Untuk Hosting Aset Web Dashboard)
# CDN Dihapus karena limitasi lisensi Azure for Students. 
# Aplikasi akan diakses langsung melalui Primary Web Endpoint dari Storage Account.
resource "azurerm_storage_container" "assets" {
  name                  = "web-assets"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "blob"
}

# 5. Output untuk mendapatkan URL Dashboard
output "dashboard_url" {
  value       = azurerm_storage_account.sa.primary_web_endpoint
  description = "Akses Dashboard Web Statis CloudStock di URL ini"
}