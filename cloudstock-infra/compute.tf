# =======================================================
# 1. VIRTUAL MACHINE & JARINGAN (IOT SIMULATOR)
# =======================================================

# Membuat Public IP (Standard SKU) agar VM bisa diakses via SSH
resource "azurerm_public_ip" "pip" {
  name                = "pip-iot-simulator"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  
  # Fix untuk menghindari limitasi Basic SKU Azure for Students
  allocation_method   = "Static"
  sku                 = "Standard" 
}

# Network Interface yang menghubungkan VM, Subnet, dan Public IP
resource "azurerm_network_interface" "nic" {
  name                = "nic-iot-simulator"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_compute.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id # Menghubungkan Public IP
  }
}

# Virtual Machine sebagai Host Simulator IoT
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-iot-simulator"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2als_v2"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./cloudstock_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# =======================================================
# 2. STORAGE ACCOUNT (BACKEND & STATIC WEB HOSTING)
# =======================================================

resource "azurerm_storage_account" "sa" {
  name                     = "sacloudstockasia777"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Konfigurasi Object Storage untuk Website Statis
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

# =======================================================
# 3. AZURE FUNCTION APP (SERVERLESS API BACKEND)
# =======================================================

# Service Plan (Consumption / Pay-as-you-go)
resource "azurerm_service_plan" "app_plan" {
  name                = "plan-cloudstock-func"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Mesin Function App
resource "azurerm_linux_function_app" "func" {
  name                       = "func-cloudstock-asia-777"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  service_plan_id            = azurerm_service_plan.app_plan.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  # Memaksa Azure menggunakan Runtime Python 3.11
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  # Mengaktifkan System Assigned Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # Environment Variables & Key Vault Reference
  app_settings = {
    "TABLE_STORAGE_CONNECTION" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_conn.id})"
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

# =======================================================
# 4. KEAMANAN (KEY VAULT ACCESS POLICY)
# =======================================================

# Memberikan izin membaca rahasia di Key Vault ke Function App
resource "azurerm_key_vault_access_policy" "func_kv_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_function_app.func.identity[0].principal_id

  secret_permissions = [
    "Get",
  ]

  depends_on = [azurerm_linux_function_app.func]
}