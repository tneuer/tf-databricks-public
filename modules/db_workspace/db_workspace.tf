resource "azurerm_databricks_workspace" "db_workspace1" {
  name                = format("%s%s", "db-workspace-", var.project)
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "premium"
  tags                = var.tags
}

resource "azurerm_databricks_access_connector" "db_workspace1" {
  name                = format("%s%s", "db-access-connector-", var.project)
  resource_group_name = var.rg_name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_storage_account" "db_metastore" {
  name                = var.db_storage_account_name
  resource_group_name = var.rg_name

  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  tags                     = var.tags
}

resource "azurerm_storage_container" "db_metastore" {
  name                  = "my-metastore"
  storage_account_name  = azurerm_storage_account.db_metastore.name
  container_access_type = "private"
}

resource "azurerm_key_vault_secret" "db_host_secret" {
  name         = "DBHostname"
  value        = format("%s%s", "https://", azurerm_databricks_workspace.db_workspace1.workspace_url)
  key_vault_id = var.key_vault_id
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_storage_container.db_metastore.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.db_workspace1.identity[0].principal_id
}
