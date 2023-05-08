# Todo:
# refactor firewal_policy_id to use data source
resource "azurerm_public_ip" "appgwpip" {
  name                = "appgw-pip"
  resource_group_name = azurerm_resource_group.tfchallenge.name
  location            = azurerm_resource_group.tfchallenge.location
  allocation_method   = "Static"
  sku = "Standard"
  domain_name_label = "yada${random_string.suffix.result}"
}

resource "azurerm_virtual_network" "appgwvnet" {
  name                = "appgw-vnet"
  resource_group_name = azurerm_resource_group.tfchallenge.name
  location            = azurerm_resource_group.tfchallenge.location
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "appgwsubnet" {
  name                 = "appgw-subnet"
  resource_group_name  = azurerm_resource_group.tfchallenge.name
  virtual_network_name = azurerm_virtual_network.appgwvnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_web_application_firewall_policy" "res-0" {
  name                = "pol1"
  resource_group_name = azurerm_resource_group.tfchallenge.name
  location            = azurerm_resource_group.tfchallenge.location
  managed_rules {
    managed_rule_set {
      version = "3.2"
    }
  }
  policy_settings {
    mode = "Detection"
  }
}

resource "azurerm_application_gateway" "res-0" {
  firewall_policy_id = azurerm_web_application_firewall_policy.res-0.id

  name                = "ch09appgw"
  resource_group_name = azurerm_resource_group.tfchallenge.name
  location            = azurerm_resource_group.tfchallenge.location



  autoscale_configuration {
    max_capacity = 3
    min_capacity = 0
  }
  backend_address_pool {
    fqdns = [azurerm_container_app.api.latest_revision_fqdn]
    name  = "api-be"
  }
  backend_address_pool {
    fqdns = [azurerm_container_app.web.latest_revision_fqdn]
    name  = "web-be"
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "api-bes"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "apiprobe"
    protocol                            = "Https"
    request_timeout                     = 20
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "web-bes"
    pick_host_name_from_backend_address = true
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 20
  }
  frontend_ip_configuration {
    name                 = "appGwPublicFrontendIpIPv4"
    public_ip_address_id = azurerm_public_ip.appgwpip.id
  }
  frontend_port {
    name = "port_80"
    port = 80
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id =  azurerm_subnet.appgwsubnet.id
    //subnet_id = "/subscriptions/1b2f6a87-f8a2-48d5-bfcf-23f8f3ffeab4/resourceGroups/ch09rg/providers/Microsoft.Network/virtualNetworks/wafvnet/subnets/default"
  }
  http_listener {
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    name                           = "mylistener"
    protocol                       = "Http"
  }

  probe {
    interval                                  = 30
    name                                      = "apiprobe"
    path                                      = "/api/healthcheck"
    pick_host_name_from_backend_http_settings = true
    protocol                                  = "Https"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    match {
      status_code = []
    }
  }
  request_routing_rule {
    http_listener_name = "mylistener"
    name               = "mylistener-rule"
    priority           = 100
    rule_type          = "PathBasedRouting"
    url_path_map_name  = "mylistener"
  }
  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }
  url_path_map {
    default_backend_address_pool_name  = "web-be"
    default_backend_http_settings_name = "web-bes"
    name                               = "mylistener"
    path_rule {
      backend_address_pool_name  = "api-be"
      backend_http_settings_name = "api-bes"
      name                       = "be-api-path"
      paths                      = ["/api/*"]
    }
  }
}

output "appgwurl" {
  value =  "http://${azurerm_public_ip.appgwpip.domain_name_label}.${azurerm_public_ip.appgwpip.location}.cloudapp.azure.com" 
}