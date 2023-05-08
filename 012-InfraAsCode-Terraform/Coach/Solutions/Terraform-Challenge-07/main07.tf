
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

# A log analytics workspace is required for container app environments
resource "azurerm_log_analytics_workspace" "thislaw" {
  name                = var.lawname
  resource_group_name = azurerm_resource_group.tfchallenge.name
  location            = azurerm_resource_group.tfchallenge.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "this" {
  name                       = "my-aca-environment"
  resource_group_name        = azurerm_resource_group.tfchallenge.name
  location                   = azurerm_resource_group.tfchallenge.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.thislaw.id
}
resource "azurerm_container_app" "myapp" {
  name                         = "example-app"
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.tfchallenge.name
  revision_mode                = "Single"
  ingress {
    external_enabled = true
    transport = "auto"
    target_port = 80
traffic_weight {
  percentage = 100
  latest_revision = true
}
  }

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}

output "containerfqdn" {
  value = azurerm_container_app.myapp.latest_revision_fqdn
}
output "containername" {
  value = azurerm_container_app.myapp.latest_revision_name
}

#####################################################



# # Create (and display) an SSH key
# resource "tls_private_key" "example_ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_sensitive_file" "ssh_private_key" {
#   content  = tls_private_key.example_ssh.private_key_pem
#   filename = "${path.module}/mysshkey"
# }

# # Put SSH private key in keyvault
# resource "azurerm_key_vault_secret" "ssh_private_key" {
#   key_vault_id = azurerm_key_vault.vault.id
#   name         = "sshprivatekey"
#   value        = tls_private_key.example_ssh.private_key_pem

# }
