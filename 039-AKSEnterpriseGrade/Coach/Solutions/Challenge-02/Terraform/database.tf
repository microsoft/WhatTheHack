resource "azurerm_subnet" "mysql" {
  name                 = "mysql"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = module.network.vnet_name
  address_prefixes     = ["10.52.2.0/24"]

  delegation {
    name = "mysql"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_private_dns_zone" "mysql" {
  name                = "private.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-vnet-link"
  resource_group_name   = azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = module.network.vnet_id
}

resource "random_password" "mysql" {
  length  = 20
  special = true
}

resource "azurerm_mysql_flexible_server" "example" {
  name                   = "mysql-${random_string.random.result}"
  location               = azurerm_resource_group.example.location
  resource_group_name    = azurerm_resource_group.example.name
  administrator_login    = "mysqlazureadmin"
  administrator_password = var.databasepassword != "" ? var.databasepassword : random_password.mysql.result
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"
  delegated_subnet_id    = azurerm_subnet.mysql.id
  private_dns_zone_id    = azurerm_private_dns_zone.mysql.id

  storage {
    size_gb = 20
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql]
}

variable "databasepassword" {
  type      = string
  sensitive = true
  default   = ""
}
