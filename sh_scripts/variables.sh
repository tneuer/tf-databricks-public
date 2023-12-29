#!/usr/bin/env bash
# General
TENANT_ID=$(az account show | jq -r '.tenantId')
SUBSCRIPTION_ID=$(az account show --query id --output tsv);
LOCATION='switzerlandnorth'
GIT_ROOT='tneuer'
TF_REPO=$(basename `git rev-parse --show-toplevel`)
PROJECT_NAME='test-project'

# Build RG
BUILD_RESOURCE_GROUP_NAME_RESOURCES='terraform-databricks-rg'

# Terraform state backend RG
TF_RESOURCE_GROUP_NAME='terraform-databricks-rg'
TF_STORAGE_ACCOUNT_NAME='tfstatefilestoragetn'
TF_CONTAINER_NAME='tfstatefiledeployment'
TF_KEYVAULT_NAME='terraform-databricks-kv'
TF_FILE_NAME='db_deployment_dev.tfstate'
TF_SECRET_NAME='DBDeploymentTfstatesecret'

# Networking
PROJECT_CIDR_RANGE='10.0.0.0/26'

# Github
GITHUB_TF_SP_NAME='TerraformDevOpsGithubAction'
GITHUB_OICD_CREDENTIALS_NAME='Github_OICD_credentials_dev'

# Databricks
DATABRICKS_TF_SP_NAME='DatabricksDevOpsGithubAction'
DATABRICKS_METASTORE_STORAGE_ACCOUNT_NAME='databricksstoragetntest'
