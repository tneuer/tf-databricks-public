resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "tfstatekv" {
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}
