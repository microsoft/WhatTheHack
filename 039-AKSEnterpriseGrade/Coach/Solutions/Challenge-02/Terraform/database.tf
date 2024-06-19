resource "azurerm_mysql_server" "example" {
  name = random_string.random.result
  #location            = azurerm_resource_group.example.location
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name

  administrator_login          = "mysqlazureadmin"
  administrator_login_password = var.databasepassword

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = false
}

resource "azurerm_private_endpoint" "example" {
  name                = "${random_string.random.result}-endpoint"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = module.network.vnet_subnets[0]

  private_service_connection {
    name                           = "${random_string.random.result}-privateserviceconnection"
    private_connection_resource_id = azurerm_mysql_server.example.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
}

variable "databasepassword" {

  type      = string
  sensitive = true
}
