#!/usr/bin/env bash
# General
TENANT_ID='bfb32e4e-6422-4fde-b3a1-922d22d6b094'
SUBSCRIPTION_ID=$(az account show --query id --output tsv);
LOCATION='switzerlandnorth'
GIT_ROOT='tneuer'
TF_REPO='terraform-databricks'

# Build RG
BUILD_RESOURCE_GROUP_NAME_RESOURCES='terraform-databricks-rg'


# Terraform RG
TF_RESOURCE_GROUP_NAME='terraform-databricks-rg'
TF_STORAGE_ACCOUNT_NAME='tfstatefilestoragetn'
TF_CONTAINER_NAME='tfstatefiledeployment'
TF_KEYVAULT_NAME='terraform-databricks-kv';
TF_FILE_NAME='db_deployment_dev.tfstate'
TF_SECRET_NAME='dbDeploymentTfstatesecret';

# Github
GITHUB_TF_SP_NAME='TerraformDevOpsGithubAction'

# Databricks
DATABRICKS_TF_SP_NAME='DatabricksDevOpsGithubAction'
