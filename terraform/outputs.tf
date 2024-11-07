output "cdn_endpoint_url" {
  value = azurerm_cdn_endpoint_custom_domain.this.host_name
}