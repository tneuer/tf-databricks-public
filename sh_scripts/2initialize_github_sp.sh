#!/usr/bin/env bash

# This script is not implemented in terraform because it's a one time setup step which creates the token used in the github actions.
# This is run once so that afterwards everything else can be deployed via CI/CD Github. This part can't be run by Github because it creates
# the resources used to authenticate by Github.
source ./sh_scripts/variables.sh $1

# Create the Service Principal
echo Creating service principal $GITHUB_TF_SP_NAME...
az ad sp create-for-rbac --name $GITHUB_TF_SP_NAME --role reader --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$TF_RESOURCE_GROUP_NAME
APP_ID=$(az ad sp list --display-name $GITHUB_TF_SP_NAME --query "[].{spID:appId}" --output tsv);
ARM_ACCESS_KEY=$(az keyvault secret show --name $TF_SECRET_NAME --vault-name $TF_KEYVAULT_NAME --query value -o tsv);

# Create github configs
mkdir configs
echo '{
    "name": "'$GITHUB_OICD_CREDENTIALS_NAME'",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "'repo:$GIT_ROOT/$TF_REPO:ref:refs/heads/main'",
    "description": "Federated identity for push to main branch.",
    "audiences": [
        "api://AzureADTokenExchange"
    ]
}' > ./configs/$GITHUB_OICD_CREDENTIALS_NAME.json

# Grant permissions
az role assignment create --assignee-object-id  $APP_ID --role contributor --subscription $SUBSCRIPTION_ID --assignee-principal-type ServicePrincipal --scope /subscriptions/$SUBSCRIPTION_ID/resourcegroups/$BUILD_RESOURCE_GROUP_NAME_RESOURCES
az keyvault set-policy --name $TF_KEYVAULT_NAME --spn $APP_ID --secret-permissions get
az ad app federated-credential create --id  $APP_ID --parameters ./configs/$GITHUB_OICD_CREDENTIALS_NAME.json
az role assignment create --assignee  $APP_ID --role "Storage Account Key Operator Service Role" --subscription $SUBSCRIPTION_ID --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$BUILD_RESOURCE_GROUP_NAME_RESOURCES/providers/Microsoft.Storage/storageAccounts/$TF_STORAGE_ACCOUNT_NAME
az role assignment create --assignee  $APP_ID --role "Storage Account Key Operator Service Role" --subscription $SUBSCRIPTION_ID --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$BUILD_RESOURCE_GROUP_NAME_RESOURCES/providers/Microsoft.Storage/storageAccounts/$DATABRICKS_METASTORE_STORAGE_ACCOUNT_NAME

ARM_ACCESS_KEY=$(az keyvault secret show --name $TF_SECRET_NAME --vault-name $TF_KEYVAULT_NAME --query value -o tsv);
# Save to Github
echo Setting Github secrets...
# gh auth login
gh secret set AZURE_CLIENT_ID --body ${APP_ID} --repos $GIT_ROOT/$TF_REPO
gh secret set AZURE_TENANT_ID --body ${TENANT_ID} --repos $GIT_ROOT/$TF_REPO
gh secret set AZURE_SUBSCRIPTION_ID --body ${SUBSCRIPTION_ID} --repos $GIT_ROOT/$TF_REPO
gh secret set AZURE_ARM_ACCESS_KEY --body ${ARM_ACCESS_KEY} --repos $GIT_ROOT/$TF_REPO
