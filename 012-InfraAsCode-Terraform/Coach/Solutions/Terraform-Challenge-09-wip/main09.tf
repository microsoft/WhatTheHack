
# Resources
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfchallenge" {
  name     = var.rgname
  location = var.location
}
#######################################


data "azurerm_container_registry" "myacr" {
  name                = var.acrname
  resource_group_name = var.acrrg
}


# A log analytics workspace is required for container app environments
resource "azurerm_log_analytics_workspace" "thislaw" {
  name                = "${var.lawname}${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.tfchallenge.name
  location            = azurerm_resource_group.tfchallenge.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "this" {
  name                       = "my-aca-environment08"
  resource_group_name        = azurerm_resource_group.tfchallenge.name
  location                   = azurerm_resource_group.tfchallenge.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.thislaw.id
}


resource "azurerm_container_app" "web" {
  name                         = "web"
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.tfchallenge.name
  revision_mode                = "Single"
  ingress {
    external_enabled = true
    transport        = "auto"
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
  secret {
    name  = "regpwd"
    value = data.azurerm_container_registry.myacr.admin_password
  }
  registry {
    server               = data.azurerm_container_registry.myacr.login_server
    username             = data.azurerm_container_registry.myacr.admin_username
    password_secret_name = "regpwd"
  }
  template {
    container {
      name   = "web"
      image  = "${data.azurerm_container_registry.myacr.login_server}/erjosito/yadaweb:1.0"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "API_URL"
        value = "https://${azurerm_container_app.api.latest_revision_fqdn}"
      }
    }
  }
}


resource "azurerm_container_app" "api" {
  name                         = "api"
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.tfchallenge.name
  revision_mode                = "Single"
  ingress {
    external_enabled = true
    transport        = "auto"
    target_port      = 8080
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
  secret {
    name  = "regpwd"
    value = data.azurerm_container_registry.myacr.admin_password
  }
  secret {
    name  = "sqlpwd"
    value = azurerm_mssql_server.this.administrator_login_password
  }
  registry {
    server               = data.azurerm_container_registry.myacr.login_server
    username             = data.azurerm_container_registry.myacr.admin_username
    password_secret_name = "regpwd"
  }
  template {
    container {
      name   = "api"
      image  = "${data.azurerm_container_registry.myacr.login_server}/erjosito/yadaapi:1.0"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "SQL_SERVER_USERNAME"
        value = azurerm_mssql_server.this.administrator_login
      }
      env {
        name  = "SQL_SERVER_FQDN"
        value = azurerm_mssql_server.this.fully_qualified_domain_name
      }
      env {
        name        = "SQL_SERVER_PASSWORD"
        secret_name = "sqlpwd"
      }
    }
  }
}

output "webfrontfqdn" {
  value = azurerm_container_app.web.latest_revision_fqdn
}

####################

resource "random_password" "password" {
  length      = 16
  special     = true
  numeric     = true
  min_numeric = 3
  min_lower   = 3
  min_special = 3
  //override_special = ".-"
}

resource "azurerm_mssql_server" "this" {
  name                         = "sqlserver${random_string.suffix.result}"
  resource_group_name          = azurerm_resource_group.tfchallenge.name
  location                     = azurerm_resource_group.tfchallenge.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = random_password.password.result
}

resource "azurerm_mssql_database" "this" {
  name           = "mydb"
  server_id      = azurerm_mssql_server.this.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "this" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = azurerm_container_app.api.outbound_ip_addresses[0]
  end_ip_address   = azurerm_container_app.api.outbound_ip_addresses[0]
}