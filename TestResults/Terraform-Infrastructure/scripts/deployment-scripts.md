# Deployment Scripts for E-Commerce Platform Terraform Infrastructure

# Script Collection Overview:
# - init-backend.sh: Initialize Terraform backend storage
# - deploy.sh: Deploy infrastructure to specific environment
# - destroy.sh: Destroy infrastructure (with safety checks)
# - validate.sh: Validate Terraform configuration
# - plan.sh: Generate and review execution plans

# =============================================================================
# INIT-BACKEND.SH - Initialize Terraform Backend Storage
# =============================================================================

#!/bin/bash

# init-backend.sh - Initialize Terraform backend storage account
# Usage: ./init-backend.sh [environment]
# Example: ./init-backend.sh prod

set -e

ENVIRONMENT=${1:-"prod"}
LOCATION=${2:-"East US 2"}
SUBSCRIPTION_ID=${3:-$(az account show --query id --output tsv)}

echo "Initializing Terraform backend for environment: $ENVIRONMENT"
echo "Location: $LOCATION"
echo "Subscription: $SUBSCRIPTION_ID"

# Set variables based on environment
case $ENVIRONMENT in
  "dev")
    RG_NAME="tfstate-rg-dev"
    STORAGE_NAME="tfstateecomdev001"
    ;;
  "staging")
    RG_NAME="tfstate-rg-staging"
    STORAGE_NAME="tfstateecomstg001"
    ;;
  "prod")
    RG_NAME="tfstate-rg-prod"
    STORAGE_NAME="tfstateecomprod001"
    ;;
  *)
    echo "Error: Invalid environment. Use: dev, staging, or prod"
    exit 1
    ;;
esac

echo "Creating resource group: $RG_NAME"
az group create \
  --name "$RG_NAME" \
  --location "$LOCATION" \
  --subscription "$SUBSCRIPTION_ID"

echo "Creating storage account: $STORAGE_NAME"
az storage account create \
  --resource-group "$RG_NAME" \
  --name "$STORAGE_NAME" \
  --sku Standard_LRS \
  --encryption-services blob \
  --https-only true \
  --kind StorageV2 \
  --access-tier Hot \
  --location "$LOCATION" \
  --subscription "$SUBSCRIPTION_ID"

echo "Creating storage container: tfstate"
az storage container create \
  --name tfstate \
  --account-name "$STORAGE_NAME" \
  --auth-mode login \
  --subscription "$SUBSCRIPTION_ID"

echo "Enabling versioning for blob storage"
az storage account blob-service-properties update \
  --account-name "$STORAGE_NAME" \
  --resource-group "$RG_NAME" \
  --enable-versioning true \
  --subscription "$SUBSCRIPTION_ID"

echo "Setting up soft delete policy"
az storage account blob-service-properties update \
  --account-name "$STORAGE_NAME" \
  --resource-group "$RG_NAME" \
  --enable-delete-retention true \
  --delete-retention-days 30 \
  --subscription "$SUBSCRIPTION_ID"

echo "Backend storage initialized successfully!"
echo "Storage Account: $STORAGE_NAME"
echo "Resource Group: $RG_NAME"
echo "Container: tfstate"

# =============================================================================
# DEPLOY.SH - Deploy Infrastructure
# =============================================================================

#!/bin/bash

# deploy.sh - Deploy infrastructure to specified environment
# Usage: ./deploy.sh [environment] [plan_only]
# Example: ./deploy.sh prod
# Example: ./deploy.sh prod plan

set -e

ENVIRONMENT=${1:-"prod"}
PLAN_ONLY=${2:-""}
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ENV_DIR="$SCRIPT_DIR/../environments/$ENVIRONMENT"

# Validate environment
if [[ ! -d "$ENV_DIR" ]]; then
    echo "Error: Environment directory not found: $ENV_DIR"
    echo "Available environments: dev, staging, prod"
    exit 1
fi

echo "Deploying to environment: $ENVIRONMENT"
echo "Working directory: $ENV_DIR"

# Change to environment directory
cd "$ENV_DIR"

# Check if backend is initialized
if [[ ! -f ".terraform/terraform.tfstate" ]]; then
    echo "Initializing Terraform backend..."
    terraform init
fi

# Validate configuration
echo "Validating Terraform configuration..."
terraform validate

# Format check
echo "Checking Terraform formatting..."
terraform fmt -check -recursive || {
    echo "Warning: Terraform files are not properly formatted"
    echo "Run 'terraform fmt -recursive' to fix formatting"
}

# Generate execution plan
echo "Generating execution plan..."
terraform plan \
  -var-file="terraform.tfvars" \
  -out="tfplan-$(date +%Y%m%d-%H%M%S).plan" \
  -detailed-exitcode

PLAN_EXIT_CODE=$?

# Handle plan results
case $PLAN_EXIT_CODE in
  0)
    echo "No changes detected. Infrastructure is up to date."
    exit 0
    ;;
  1)
    echo "Error: Terraform plan failed"
    exit 1
    ;;
  2)
    echo "Changes detected. Plan generated successfully."
    ;;
esac

# If plan_only flag is set, exit here
if [[ "$PLAN_ONLY" == "plan" ]]; then
    echo "Plan-only mode. Exiting without applying changes."
    exit 0
fi

# Production safety check
if [[ "$ENVIRONMENT" == "prod" ]]; then
    echo ""
    echo "⚠️  WARNING: You are about to deploy to PRODUCTION ⚠️"
    echo "This will make changes to production infrastructure."
    echo ""
    read -p "Type 'YES' to continue with production deployment: " -r
    if [[ ! $REPLY == "YES" ]]; then
        echo "Production deployment cancelled."
        exit 0
    fi
fi

# Apply changes
echo "Applying changes..."
terraform apply tfplan-*.plan

echo "Deployment completed successfully!"

# Generate outputs
echo "Generating outputs..."
terraform output -json > "outputs-$(date +%Y%m%d-%H%M%S).json"

echo "Deployment summary:"
terraform output

# =============================================================================
# DESTROY.SH - Destroy Infrastructure (with safety checks)
# =============================================================================

#!/bin/bash

# destroy.sh - Destroy infrastructure with safety checks
# Usage: ./destroy.sh [environment]
# Example: ./destroy.sh dev

set -e

ENVIRONMENT=${1:-""}
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Validate environment parameter
if [[ -z "$ENVIRONMENT" ]]; then
    echo "Error: Environment parameter is required"
    echo "Usage: ./destroy.sh [environment]"
    echo "Available environments: dev, staging, prod"
    exit 1
fi

ENV_DIR="$SCRIPT_DIR/../environments/$ENVIRONMENT"

# Validate environment directory
if [[ ! -d "$ENV_DIR" ]]; then
    echo "Error: Environment directory not found: $ENV_DIR"
    exit 1
fi

echo "🚨 DANGER: About to destroy infrastructure in environment: $ENVIRONMENT"
echo "Working directory: $ENV_DIR"

# Production protection
if [[ "$ENVIRONMENT" == "prod" ]]; then
    echo ""
    echo "❌ PRODUCTION DESTRUCTION BLOCKED ❌"
    echo "Production infrastructure destruction is not allowed via script."
    echo "If you need to destroy production resources:"
    echo "1. Manually run terraform destroy in the prod directory"
    echo "2. Provide additional confirmation prompts"
    echo "3. Have proper approval from stakeholders"
    echo ""
    exit 1
fi

# Double confirmation for non-production
echo ""
echo "You are about to destroy ALL infrastructure in: $ENVIRONMENT"
echo "This action cannot be undone!"
echo ""
read -p "Type '$ENVIRONMENT' to confirm destruction: " -r
if [[ ! $REPLY == "$ENVIRONMENT" ]]; then
    echo "Destruction cancelled."
    exit 0
fi

echo ""
read -p "Type 'DESTROY' to confirm you want to destroy all resources: " -r
if [[ ! $REPLY == "DESTROY" ]]; then
    echo "Destruction cancelled."
    exit 0
fi

# Change to environment directory
cd "$ENV_DIR"

# Generate destruction plan
echo "Generating destruction plan..."
terraform plan -destroy -out="destroy.plan"

echo ""
echo "Destruction plan generated. Review the plan above."
read -p "Proceed with destruction? (yes/no): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Destruction cancelled."
    exit 0
fi

# Apply destruction
echo "Destroying infrastructure..."
terraform apply destroy.plan

echo "Infrastructure destroyed successfully."

# Clean up plan files
rm -f *.plan

# =============================================================================
# VALIDATE.SH - Validate Terraform Configuration
# =============================================================================

#!/bin/bash

# validate.sh - Validate Terraform configuration across all environments
# Usage: ./validate.sh [environment]
# Example: ./validate.sh prod
# Example: ./validate.sh (validates all environments)

set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SPECIFIC_ENV=${1:-""}

validate_environment() {
    local env=$1
    local env_dir="$SCRIPT_DIR/../environments/$env"
    
    if [[ ! -d "$env_dir" ]]; then
        echo "❌ Environment directory not found: $env_dir"
        return 1
    fi
    
    echo "Validating environment: $env"
    cd "$env_dir"
    
    # Initialize if needed (without backend)
    if [[ ! -d ".terraform" ]]; then
        echo "  Initializing Terraform..."
        terraform init -backend=false
    fi
    
    # Validate syntax
    echo "  Checking syntax..."
    if ! terraform validate; then
        echo "❌ Validation failed for $env"
        return 1
    fi
    
    # Check formatting
    echo "  Checking formatting..."
    if ! terraform fmt -check -recursive; then
        echo "⚠️  Formatting issues found in $env"
        echo "   Run 'terraform fmt -recursive' to fix"
    fi
    
    # Security check (if tfsec is available)
    if command -v tfsec &> /dev/null; then
        echo "  Running security checks..."
        tfsec . || echo "⚠️  Security issues found in $env"
    fi
    
    echo "✅ Validation completed for $env"
    echo ""
}

# Main execution
if [[ -n "$SPECIFIC_ENV" ]]; then
    validate_environment "$SPECIFIC_ENV"
else
    echo "Validating all environments..."
    echo ""
    
    for env in dev staging prod; do
        if validate_environment "$env"; then
            echo "Environment $env: ✅ PASSED"
        else
            echo "Environment $env: ❌ FAILED"
            exit 1
        fi
    done
    
    echo "All environments validated successfully! ✅"
fi

# =============================================================================
# PLAN.SH - Generate and Review Execution Plans
# =============================================================================

#!/bin/bash

# plan.sh - Generate execution plan for specified environment
# Usage: ./plan.sh [environment] [target_resource]
# Example: ./plan.sh prod
# Example: ./plan.sh staging module.aks

set -e

ENVIRONMENT=${1:-"prod"}
TARGET=${2:-""}
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ENV_DIR="$SCRIPT_DIR/../environments/$ENVIRONMENT"

# Validate environment
if [[ ! -d "$ENV_DIR" ]]; then
    echo "Error: Environment directory not found: $ENV_DIR"
    exit 1
fi

echo "Generating execution plan for environment: $ENVIRONMENT"
if [[ -n "$TARGET" ]]; then
    echo "Target resource: $TARGET"
fi

# Change to environment directory
cd "$ENV_DIR"

# Initialize if needed
if [[ ! -f ".terraform/terraform.tfstate" ]]; then
    echo "Initializing Terraform..."
    terraform init
fi

# Generate timestamp for plan file
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
PLAN_FILE="tfplan-$TIMESTAMP.plan"

# Build terraform plan command
PLAN_CMD="terraform plan -var-file=terraform.tfvars -out=$PLAN_FILE"
if [[ -n "$TARGET" ]]; then
    PLAN_CMD="$PLAN_CMD -target=$TARGET"
fi

# Execute plan
echo "Executing: $PLAN_CMD"
eval $PLAN_CMD

echo ""
echo "Plan saved to: $PLAN_FILE"
echo ""
echo "To apply this plan, run:"
echo "  terraform apply $PLAN_FILE"
echo ""
echo "To view the plan in detail:"
echo "  terraform show $PLAN_FILE"
echo ""

# Clean up old plan files (keep last 5)
echo "Cleaning up old plan files..."
ls -t tfplan-*.plan 2>/dev/null | tail -n +6 | xargs -r rm --

echo "Plan generation completed!"

# =============================================================================
# USAGE INSTRUCTIONS
# =============================================================================

# Make scripts executable:
# chmod +x scripts/*.sh

# Initialize backend (run once per environment):
# ./scripts/init-backend.sh prod

# Deploy infrastructure:
# ./scripts/deploy.sh prod

# Generate plan only:
# ./scripts/deploy.sh prod plan

# Validate configuration:
# ./scripts/validate.sh prod

# Generate execution plan:
# ./scripts/plan.sh prod

# Destroy infrastructure (non-production only):
# ./scripts/destroy.sh dev
