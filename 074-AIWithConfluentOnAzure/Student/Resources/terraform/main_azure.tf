# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.name_prefix}-confluentwth-rg"
  location = var.resource_group_location
}



resource "azurerm_storage_account" "storage" {
  name                     = "${var.name_prefix}sa"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  account_kind             = "StorageV2"
  public_network_access_enabled = true
  shared_access_key_enabled = true
}

# Define a list of blob container names
locals {
  container_names = [
    "departments",
    "product-pricing",
    "product-skus"
  ]
}

# Create containers using a loop
resource "azurerm_storage_container" "containers" {
  for_each              = toset(local.container_names)
  name                  = each.value
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

# Azure AI Search Instance
# New changes to the Azure Search Service API require the use of 
# `local_authentication_enabled` and `authentication_failure_mode` properties.
# These properties are required to enable local authentication and set the failure mode.
# The `public_network_access_enabled` property is also set to true to allow public access.
# https://learn.microsoft.com/en-us/azure/search/search-security-enable-roles?tabs=config-svc-rest%2Cdisable-keys-cli
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/search_service
resource "azurerm_search_service" "search" {
  name                = "${var.name_prefix}-search"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "standard"
  partition_count     = 1
  replica_count       = 1
  local_authentication_enabled = true
  authentication_failure_mode = "http403"
  public_network_access_enabled = true

  depends_on = [ azurerm_storage_container.containers ]
}

# Azure Cosmos DB (SQL API)
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "${var.name_prefix}cosmos"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  public_network_access_enabled = true
  local_authentication_disabled = false


  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }

  depends_on = [ azurerm_storage_container.containers ]
}

# Cosmos DB SQL Database
resource "azurerm_cosmosdb_sql_database" "retailstore" {
  name                = "retailstore"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name

  throughput          = 400 # Provisioned throughput at the database level (optional if you want)
}

# Purchases Container
resource "azurerm_cosmosdb_sql_container" "purchases" {
  name                = "purchases"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.retailstore.name

  partition_key_paths  = ["/customer_id"]
  throughput          = 400 # optional: you can set throughput here too, or rely on database throughput
}

# Returns Container
resource "azurerm_cosmosdb_sql_container" "returns" {
  name                = "returns"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.retailstore.name

  partition_key_paths  = ["/customer_id"]
  throughput          = 400
}

# Replenishments Container
resource "azurerm_cosmosdb_sql_container" "replenishments" {
  name                = "replenishments"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.retailstore.name

  partition_key_paths  = ["/vendor_id"]
  throughput          = 400
}

# Azure Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                            = "${var.name_prefix}redis"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  capacity                        = 1
  family                          = "C"
  sku_name                        = "Standard"
  non_ssl_port_enabled               = false
  minimum_tls_version            = "1.2"
  public_network_access_enabled  = true
  redis_version                  = "6"
  shard_count                        = 0
  
  redis_configuration {
    active_directory_authentication_enabled = true
    aof_backup_enabled                      = false
    authentication_enabled                  = true
    maxfragmentationmemory_reserved         = 125
    maxmemory_delta                         = 125
    maxmemory_reserved                      = 125
    notify_keyspace_events                  = ""
  }
}

# Azure AI Services (AI Foundry)
resource "azurerm_ai_services" "ai_services" {
  name                = "${var.name_prefix}aiservices"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name           = "S0"
  custom_subdomain_name = "${var.name_prefix}models"
  
  local_authentication_enabled       = true
  public_network_access      = "Enabled"
  outbound_network_access_restricted = false
  
  identity {
    type = "SystemAssigned"
  }
  
  network_acls {
    default_action = "Allow"
  }
}