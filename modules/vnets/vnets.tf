data "azurerm_client_config" "current" {}

resource "azurerm_virtual_network" "vnet" {
  name                = format("%s%s", "vnet-", var.project)
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.vnet_cidr_range]
  tags                = var.tags
}

resource "azurerm_subnet" "db_storage" {
  name                 = format("%s%s", "db-storage-", var.project)
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr_range, 2, 0)]
}
