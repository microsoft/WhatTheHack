# Create public IPs
resource "azurerm_public_ip" "pip" {
  name                         = "${var.name}-pip"
  location                     = var.az_region
  resource_group_name          = var.az_resource_group
  public_ip_address_allocation = var.public_ip_allocation_type
  domain_name_label            = "${lower(var.name)}-${lower(var.az_domain_name)}"

  idle_timeout_in_minutes = 30

  tags = {
    environment = "Terraform SAP HANA deployment"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  depends_on                = [azurerm_public_ip.pip]
  name                      = "${var.name}-nic"
  location                  = var.az_region
  resource_group_name       = var.az_resource_group
  network_security_group_id = var.nsg_id
  enable_accelerated_networking = "true"

  ip_configuration {
    name      = "${var.name}-nic-configuration"
    subnet_id = var.subnet_id

    load_balancer_backend_address_pools_ids = var.backend_ip_pool_ids
    private_ip_address_allocation           = var.private_ip_address != local.empty_string ? local.static : local.dynamic
    private_ip_address                      = var.private_ip_address
    public_ip_address_id                    = azurerm_public_ip.pip.id
  }

  tags = {
    environment = "Terraform SAP HANA deployment"
  }
}

