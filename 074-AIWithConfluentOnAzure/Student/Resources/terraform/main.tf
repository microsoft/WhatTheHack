
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }

    confluent = {
      source  = "confluentinc/confluent"
      version = "2.35.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }

  required_version = ">= 1.12.2"
}

provider "random" {
  # Random provider configuration
  # This can be left empty or configured as needed
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  storage_use_azuread = true
}

provider "confluent" {
  kafka_id            = var.kafka_id                   # optionally use KAFKA_ID env var
  kafka_rest_endpoint = var.kafka_rest_endpoint        # optionally use KAFKA_REST_ENDPOINT env var
  kafka_api_key       = var.kafka_api_key              # optionally use KAFKA_API_KEY env var
  kafka_api_secret    = var.kafka_api_secret           # optionally use KAFKA_API_SECRET env var

  flink_api_key       = var.flink_api_key              # optionally use FLINK_API_KEY env var
  flink_api_secret    = var.flink_api_secret           # optionally use FLINK_API_SECRET env var
  flink_rest_endpoint = var.flink_rest_endpoint        # optionally use FLINK_REST_ENDPOINT env var
  flink_compute_pool_id = var.flink_compute_pool_id    # optionally use FLINK_COMPUTE_POOL_ID env var
  flink_principal_id  = var.flink_principal_id         # optionally use FLINK_PRINCIPAL_ID 
  organization_id   = var.confluent_organization_id    # optionally use ORGANIZATION_ID env var
  environment_id   = var.confluent_environment_id      # optionally use ENVIRONMENT_ID env var

  schema_registry_id = var.schema_registry_id                       # optionally use SCHEMA_REGISTRY_ID env var
  schema_registry_rest_endpoint = var.schema_registry_rest_endpoint # optionally use SCHEMA_REGISTRY_REST_ENDPOINT env var
  schema_registry_api_key = var.schema_registry_api_key             # optionally use SCHEMA_REGISTRY_API_KEY env var
  schema_registry_api_secret = var.schema_registry_api_secret       # optionally use SCHEMA_REGISTRY_API_SECRET env var

  # Confluent Cloud API (for managing connectors and environments)
  cloud_api_key    = var.cloud_api_key
  cloud_api_secret = var.cloud_api_secret
}

# New variables for merged changes
variable "cloud_api_key" { type = string }
variable "cloud_api_secret" { type = string }

# -----------------
# Core Confluent IDs / Endpoints
# -----------------
variable "kafka_id" { type = string }
variable "kafka_rest_endpoint" { type = string }
variable "kafka_api_key" { type = string }
variable "kafka_api_secret" { type = string }
variable "flink_api_key" { type = string }
variable "flink_api_secret" { type = string }
variable "flink_rest_endpoint" { type = string }
variable "flink_compute_pool_id" { type = string }
variable "flink_principal_id" { type = string }
variable "confluent_organization_id" { type = string }
variable "confluent_environment_id" { type = string }
variable "schema_registry_id" { type = string }
variable "schema_registry_rest_endpoint" { type = string }
variable "schema_registry_api_key" { type = string }
variable "schema_registry_api_secret" { type = string }
variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string

  validation {
    condition     = length(var.name_prefix) <= 6 && can(regex("^[a-z0-9]+$", var.name_prefix))
    error_message = "The name_prefix must be 6 characters or fewer and contain only lowercase letters (a-z) or numbers (0-9)."
  }
}

# -----------------
# Azure variables
# -----------------
variable "resource_group_location" {
  type    = string
  default = "eastus2"
}
variable "azure_subscription_id" { type = string }

/*
# Service Principal (for Azure Search connector) - supply if using AI Search connectors
variable "service_principal_tenant_id" { type = string }
variable "service_principal_subscription_id" { type = string }
variable "service_principal_client_id" { type = string }
variable "service_principal_client_secret" { type = string }
*/


# -----------------
# Kafka topic configuration
# -----------------
variable "kafka_partitions_count" {
  type    = number
  default = 6
}

# -----------------
# Connector Maps
# -----------------
variable "blob_store_connectors" {
  description = "Blob source connectors map"
  type = map(object({
    name      = string
    topic     = string
    container = string
  }))
  default = {}
}



variable "cosmos_db_connectors" {
  description = "Cosmos DB source connectors map"
  type = map(object({
    name  = string
    topic = string
  }))
  default = {}
}

variable "ai_search_connectors" {
  description = "Azure AI Search sink connectors map"
  type = map(object({
    name  = string
    topic = string
    index = string
  }))
  default = {}
}
