data "archive_file" "function_code" {
  type = "zip"

  output_path = "${path.module}/${local.function_code_directory}/${local.function_zip_file}"
  source_dir  = "${path.module}/${local.function_code_directory}/"

  excludes = ["*.zip"]
}

locals {
  app_file = "App.js"

  app_function_os_type = title(var.function_app_os_type)

  function_code_directory = "function-code"

  function_zip_file = "function_code.zip"
}

resource "azurerm_linux_function_app" "this" {
  name                = "${local.project}-functions"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key
  service_plan_id            = azurerm_service_plan.this.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      node_version = "20"
    }

    cors {
      allowed_origins = [
        "https://${local.site_domain}"
      ]
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "${azurerm_storage_account.this.primary_blob_endpoint}${local.function_code_directory}/${local.function_zip_file}"
  }
}

resource "azurerm_role_assignment" "function_storage_access" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_function_app.this.identity[0].principal_id
}

resource "azurerm_service_plan" "this" {
  name = "${local.project}-service-plan"

  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  os_type  = local.app_function_os_type
  sku_name = "B1"
}

resource "azurerm_storage_blob" "function_code" {
  name = local.function_zip_file

  content_md5            = data.archive_file.function_code.output_md5
  source                 = data.archive_file.function_code.output_path
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.function_code.name
  type                   = "Block"
}
