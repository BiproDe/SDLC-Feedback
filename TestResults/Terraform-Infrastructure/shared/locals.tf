# Local values for resource naming and tagging
locals {
  # Environment-specific settings
  environment_config = {
    dev = {
      short_name    = "d"
      vm_size_tier  = "standard"
      enable_backup = false
      cost_center   = "development"
    }
    staging = {
      short_name    = "s"
      vm_size_tier  = "standard"
      enable_backup = true
      cost_center   = "staging"
    }
    prod = {
      short_name    = "p"
      vm_size_tier  = "premium"
      enable_backup = true
      cost_center   = "production"
    }
  }

  # Current environment configuration
  env_config = local.environment_config[var.environment]

  # Resource naming convention: {project}-{resource-type}-{environment}-{region}-{instance}
  naming_convention = {
    # Core naming components
    project_short     = substr(var.project_name, 0, 8)
    environment_short = local.env_config.short_name
    location_short    = local.location_short_names[var.location]
    
    # Resource type abbreviations
    resource_types = {
      resource_group          = "rg"
      virtual_network         = "vnet"
      subnet                 = "snet"
      network_security_group = "nsg"
      public_ip              = "pip"
      load_balancer          = "lb"
      application_gateway    = "agw"
      kubernetes_cluster     = "aks"
      container_registry     = "acr"
      key_vault             = "kv"
      storage_account       = "st"
      sql_server            = "sql"
      sql_database          = "sqldb"
      cosmosdb_account      = "cosmos"
      redis_cache           = "redis"
      log_analytics         = "log"
      application_insights  = "appi"
      front_door            = "fd"
      api_management        = "apim"
      recovery_vault        = "rsv"
      automation_account    = "aa"
    }
  }

  # Location short name mappings
  location_short_names = {
    "East US"         = "eus"
    "East US 2"       = "eus2" 
    "West US"         = "wus"
    "West US 2"       = "wus2"
    "West US 3"       = "wus3"
    "Central US"      = "cus"
    "North Central US" = "ncus"
    "South Central US" = "scus"
    "West Central US" = "wcus"
    "Canada Central"  = "cac"
    "Canada East"     = "cae"
    "North Europe"    = "ne"
    "West Europe"     = "we"
    "UK South"        = "uks"
    "UK West"         = "ukw"
    "France Central"  = "fc"
    "Germany West Central" = "gwc"
    "Switzerland North" = "swn"
    "Norway East"     = "noe"
    "Sweden Central"  = "sec"
  }

  # Common resource names
  resource_names = {
    # Primary resource group
    resource_group = var.resource_group_name != "" ? var.resource_group_name : "${local.naming_convention.project_short}-${local.naming_convention.resource_types.resource_group}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    
    # Networking resources
    virtual_network = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.virtual_network}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    
    # AKS resources  
    aks_cluster = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.kubernetes_cluster}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    container_registry = "${local.naming_convention.project_short}${local.naming_convention.resource_types.container_registry}${local.naming_convention.environment_short}${local.naming_convention.location_short}"
    
    # Data resources
    sql_server = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.sql_server}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    cosmosdb_account = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.cosmosdb_account}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    redis_cache = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.redis_cache}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    
    # Security resources
    key_vault = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.key_vault}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    
    # Monitoring resources
    log_analytics = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.log_analytics}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    application_insights = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.application_insights}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    
    # Front Door resources
    front_door = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.front_door}-${local.naming_convention.environment_short}"
    
    # API Management (if enabled)
    api_management = "${local.naming_convention.project_short}-${local.naming_convention.resource_types.api_management}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
    
    # Storage accounts (must be globally unique, lowercase, no hyphens)
    storage_account = "${local.naming_convention.project_short}${local.naming_convention.resource_types.storage_account}${local.naming_convention.environment_short}${local.naming_convention.location_short}${random_string.storage_suffix.result}"
  }

  # Subnet names
  subnet_names = {
    for key, value in var.subnet_configurations :
    key => "${local.naming_convention.project_short}-${local.naming_convention.resource_types.subnet}-${key}-${local.naming_convention.environment_short}-${local.naming_convention.location_short}"
  }

  # Common tags applied to all resources
  common_tags = merge(
    {
      Environment         = var.environment
      Project            = var.project_name
      ManagedBy          = "Terraform"
      CostCenter         = local.env_config.cost_center
      Owner              = "Platform Team"
      BusinessUnit       = "E-Commerce"
      Application        = "E-Commerce Platform"
      DataClassification = var.environment == "prod" ? "Confidential" : "Internal"
      Backup             = local.env_config.enable_backup ? "Required" : "NotRequired"
      DR                 = var.environment == "prod" ? "Required" : "NotRequired"
      Monitoring         = "Required"
      CreatedDate        = formatdate("YYYY-MM-DD", timestamp())
    },
    var.tags
  )

  # Environment-specific database configurations
  database_config = {
    dev = {
      sql_sku = "Basic"
      sql_tier = "Basic"
      cosmos_throughput = 400
      redis_sku = "Standard"
      backup_retention = 7
    }
    staging = {
      sql_sku = "Standard"
      sql_tier = "S2"
      cosmos_throughput = 1000
      redis_sku = "Premium"
      backup_retention = 14
    }
    prod = {
      sql_sku = "Premium"
      sql_tier = "P2"
      cosmos_throughput = 4000
      redis_sku = "Premium"
      backup_retention = 35
    }
  }

  # Current environment database config
  db_config = local.database_config[var.environment]

  # Network Security Groups rules
  nsg_rules = {
    application_gateway = [
      {
        name                       = "AllowHTTPS"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowHTTP"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowAzureInfrastructure"
        priority                   = 1020
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "GatewayManager"
        destination_address_prefix = "*"
      }
    ]
    
    aks_nodes = [
      {
        name                       = "AllowAKSApiServer"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "AzureCloud"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowSSH"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.subnet_configurations["application-gateway"].address_prefixes[0]
        destination_address_prefix = "*"
      }
    ]
    
    database = [
      {
        name                       = "AllowAKSNodes"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["1433", "3306", "5432"]
        source_address_prefix      = var.subnet_configurations["aks-nodes"].address_prefixes[0]
        destination_address_prefix = "*"
      },
      {
        name                       = "DenyAllInbound"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  # Key Vault access policies
  key_vault_access_policies = {
    terraform_client = {
      object_id = data.azurerm_client_config.current.object_id
      key_permissions = [
        "Get", "List", "Update", "Create", "Import", "Delete", "Recover", 
        "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", 
        "Verify", "Sign", "Purge"
      ]
      secret_permissions = [
        "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
      ]
      certificate_permissions = [
        "Get", "List", "Update", "Create", "Import", "Delete", "Recover", 
        "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", 
        "SetIssuers", "DeleteIssuers", "Purge"
      ]
    }
  }

  # Conditional resource configurations
  conditional_configs = {
    # Enable certain features only in production
    enable_zone_redundancy = var.environment == "prod"
    enable_geo_replication = var.environment == "prod"
    enable_advanced_monitoring = var.environment == "prod"
    
    # Cost optimization for non-production
    use_burstable_sku = var.environment != "prod"
    enable_auto_shutdown = var.environment != "prod"
  }
}

# Random string for storage account uniqueness
resource "random_string" "storage_suffix" {
  length  = 4
  special = false
  upper   = false
  numeric = true
}

# Current Azure client configuration
data "azurerm_client_config" "current" {}

# Random password for SQL Server admin
resource "random_password" "sql_admin_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}
