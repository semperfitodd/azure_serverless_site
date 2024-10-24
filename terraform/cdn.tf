resource "azurerm_cdn_profile" "this" {
  name = local.project

  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  sku = var.cdn_profile_sku
}

resource "azurerm_cdn_endpoint" "this" {
  name = local.project

  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  optimization_type  = "GeneralWebDelivery"
  origin_host_header = azurerm_storage_account.this.primary_blob_host
  origin_path        = "/${local.storage_sitefiles_path}"
  profile_name       = azurerm_cdn_profile.this.name

  origin {
    name       = local.project
    host_name  = azurerm_storage_account.this.primary_blob_host
    http_port  = 80
    https_port = 443
  }

  is_compression_enabled    = true
  content_types_to_compress = ["text/html", "text/css", "application/javascript"]

  is_http_allowed  = false
  is_https_allowed = true
}

resource "azurerm_cdn_endpoint_custom_domain" "this" {
  name            = replace(local.site_domain, ".", "-")
  cdn_endpoint_id = azurerm_cdn_endpoint.this.id
  host_name       = local.site_domain

  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
    tls_version      = "TLS12"
  }
}
