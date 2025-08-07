# Terraform Backend Configuration for Production Environment

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg-prod"
    storage_account_name = "tfstateecomprod001"
    container_name       = "tfstate"
    key                  = "ecommerce/prod/terraform.tfstate"
    
    # Optional: Use managed identity for authentication
    # use_msi = true
    
    # Optional: Use specific subscription
    # subscription_id = "your-subscription-id"
    
    # Optional: Use Azure CLI authentication
    # use_azuread_auth = true
  }
}

# Backend Storage Account Setup (Run once before terraform init)
# 
# Prerequisites: Run the following Azure CLI commands to create the backend storage:
#
# 1. Create Resource Group for Terraform State
# az group create --name tfstate-rg-prod --location "East US 2"
#
# 2. Create Storage Account for Terraform State  
# az storage account create \
#   --resource-group tfstate-rg-prod \
#   --name tfstateecomprod001 \
#   --sku Standard_LRS \
#   --encryption-services blob \
#   --https-only true \
#   --kind StorageV2 \
#   --access-tier Hot \
#   --location "East US 2"
#
# 3. Create Storage Container
# az storage container create \
#   --name tfstate \
#   --account-name tfstateecomprod001 \
#   --auth-mode login
#
# 4. Enable versioning (recommended for production)
# az storage account blob-service-properties update \
#   --account-name tfstateecomprod001 \
#   --resource-group tfstate-rg-prod \
#   --enable-versioning true
#
# 5. Configure retention policy (optional)
# az storage account management-policy create \
#   --account-name tfstateecomprod001 \
#   --resource-group tfstate-rg-prod \
#   --policy @retention-policy.json

# Example retention-policy.json:
# {
#   "rules": [
#     {
#       "name": "DeleteOldVersions",
#       "enabled": true,
#       "type": "Lifecycle",
#       "definition": {
#         "filters": {
#           "blobTypes": ["blockBlob"]
#         },
#         "actions": {
#           "version": {
#             "delete": {
#               "daysAfterCreationGreaterThan": 30
#             }
#           }
#         }
#       }
#     }
#   ]
# }
