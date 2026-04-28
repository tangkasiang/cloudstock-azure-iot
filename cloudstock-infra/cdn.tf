# =======================================================
# KONFIGURASI AZURE FRONT DOOR (PENGGANTI CDN MODERN)
# =======================================================

# 1. Front Door Profile (Wadah Utama CDN Modern)
resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "fd-profile-cloudstock"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

# 2. Front Door Endpoint (Pintu gerbang publik / URL)
resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "fd-cloudstock-asia-777"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

# 3. Origin Group (Grup Server Asal)
resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = "cloudstock-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Http"
    interval_in_seconds = 100
  }
}

# 4. Origin (Mengarahkan CDN ke Static Website Blob Storage)
resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  name                           = "cloudstock-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  enabled                        = true
  host_name                      = azurerm_storage_account.sa.primary_web_host
  origin_host_header             = azurerm_storage_account.sa.primary_web_host
  http_port                      = 80
  https_port                     = 443
  certificate_name_check_enabled = false
}

# 5. Route (Aturan pengiriman dari pengguna ke Storage)
resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "cloudstock-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fd_origin.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpOnly"
  link_to_default_domain        = true
  https_redirect_enabled        = true
}

# Output untuk mendapatkan URL CDN/Front Door kamu nanti
output "cdn_url" {
  value = "https://${azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name}"
}