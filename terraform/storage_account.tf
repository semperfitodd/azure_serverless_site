locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
    "ico"  = "image/ico"
    "jpg"  = "image/jpeg"
    "js"   = "application/javascript"
    "json" = "application/json"
    "map"  = "application/octet-stream"
    "png"  = "image/png"
    "svg"  = "image/svg+xml"
    "txt"  = "text/plain"
  }

  site_files_dir = "${path.module}/site_files"

  site_files_index_template_dir = "${path.module}/site_files_index_template"

  storage_sitefiles_path = "www"
}

resource "azurerm_storage_account" "this" {
  name = replace(var.project, "_", "")

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.sitefiles.name
  type                   = "Block"
  content_type           = "text/html"

  source_content = templatefile("${local.site_files_index_template_dir}/index.html.tmpl", {
    function_app_url = azurerm_linux_function_app.this.default_hostname
    function_name    = azurerm_linux_function_app.this.name
  })
}

resource "azurerm_storage_blob" "site_files" {
  for_each = fileset(local.site_files_dir, "**/*")

  name = each.value

  content_type           = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
  source                 = "${local.site_files_dir}/${each.value}"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.sitefiles.name
  type                   = "Block"
}

resource "azurerm_storage_container" "function_code" {
  name                  = local.function_code_directory
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "sitefiles" {
  name                  = local.storage_sitefiles_path
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "blob"
}
