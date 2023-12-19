terraform {
  required_version = ">= 1.6.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.43.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

module "vnets" {
  source          = "./modules/vnets"
  rg_name         = var.rg_name
  location        = var.location
  project         = var.project
  vnet_cidr_range = var.vnet_cidr_range
  tags            = local.tags
}

module "db_workspace" {
  source                  = "./modules/db_workspace"
  rg_name                 = var.rg_name
  location                = var.location
  project                 = var.project
  db_storage_account_name = var.db_storage_account_name
  db_storage_subnet_id    = module.vnets.db_storage_subnet_id
  key_vault_id            = azurerm_key_vault.tfstatekv.id
  tags                    = local.tags
}

output "db_workspace" {
  value = module.db_workspace
}
