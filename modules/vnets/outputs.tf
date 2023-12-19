output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "db_storage_subnet_id" {
  value = azurerm_subnet.db_storage.id
}
