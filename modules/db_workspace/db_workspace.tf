resource "azurerm_databricks_workspace" "db_workspace1" {
  name                        = format("%s%s", var.project, "-workspace")
  resource_group_name         = var.rg_name
  location                    = var.location
  sku                         = "premium"
  managed_resource_group_name = var.db_storage_account_name
  tags                        = var.tags
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.db_workspace1.id
}
