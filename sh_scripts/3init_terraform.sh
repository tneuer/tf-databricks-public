#!/usr/bin/env bash
source ./sh_scripts/variables.sh $1

# Initialize Terraform backend configs
echo resource_group_name  = \"$TF_RESOURCE_GROUP_NAME\" > ./configs/config$ENV_SUFFIX4.azure.tfbackend
echo storage_account_name  = \"$TF_STORAGE_ACCOUNT_NAME\" >> ./configs/config$ENV_SUFFIX4.azure.tfbackend
echo container_name  = \"$TF_CONTAINER_NAME\" >> ./configs/config$ENV_SUFFIX4.azure.tfbackend
echo key  = \"$TF_FILE_NAME\" >> ./configs/config$ENV_SUFFIX4.azure.tfbackend

# Initialize Terraform variables
echo location = \"$LOCATION\" > ./terraform.tfvars
echo project = \"$PROJECT_NAME\" >> ./terraform.tfvars
echo key_vault_name = \"$TF_KEYVAULT_NAME\" >> ./terraform.tfvars
echo vnet_cidr_range = \"$PROJECT_CIDR_RANGE\" >> ./terraform.tfvars
echo rg_name = \"$TF_RESOURCE_GROUP_NAME\" >> ./terraform.tfvars
echo db_storage_account_name = \"$DATABRICKS_METASTORE_STORAGE_ACCOUNT_NAME\" >> ./terraform.tfvars
echo >> ./terraform.tfvars

# Init & Import resources
terraform init -backend-config="./configs/config$ENV_SUFFIX4.azure.tfbackend";
terraform import 'azurerm_resource_group.rg' /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$BUILD_RESOURCE_GROUP_NAME_RESOURCES
terraform import 'azurerm_key_vault.tfstatekv' /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$BUILD_RESOURCE_GROUP_NAME_RESOURCES/providers/Microsoft.KeyVault/vaults/$TF_KEYVAULT_NAME
