# Outputs (Used Later for Setting Up Confluent Resources)
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "cosmosdb_endpoint" {
  description = "Endpoint URI for CosmosDB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "cosmosdb_account_name" {
  description = "The name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmosdb.name
}

output "cosmosdb_primary_key" {
  description = "Primary key for CosmosDB Account"
  value       = azurerm_cosmosdb_account.cosmosdb.primary_key
  sensitive   = true
}

output "cosmosdb_database_name" {
  description = "The name of the Cosmos DB SQL database"
  value       = azurerm_cosmosdb_sql_database.retailstore.name
}

output "search_service_name" {
  description = "The name of the Azure AI Search instance"
  value       = azurerm_search_service.search.name
}

output "azure_search_admin_key" {
  description = "Primary Admin Key for Azure AI Search"
  value       = azurerm_search_service.search.primary_key
  sensitive   = true
}

output "azure_search_query_key" {
  description = "Primary Query Key for Azure AI Search"
  value       = azurerm_search_service.search.query_keys[0].key
  sensitive   = true
}

output "azure_search_endpoint" {
  description = "Endpoint URI for Azure AI Search"
  value       = azurerm_search_service.search.name
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage.name
}

output "storage_account_primary_access_key" {
  description = "Primary Access Key for Azure Storage Account"
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
}

output "storage_account_blob_endpoint" {
  description = "Blob service endpoint for the storage account"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}



