/*-----------------------------------------------------------------------------8
|                                                                              |
|                                RESOURCE GROUP                                |
|                                                                              |
+--------------------------------------4--------------------------------------*/
resource  azurerm_resource_group library {
  # Naming Standard:  {DEPLOYZONE}-{REGION_MAP}-LIBRARY
  name                                  = "${upper(var.deployZone)}-${
                                             upper(lookup(var.regionMap, var.region, "unknown"))}-SAP_LIBRARY"

  location                              = var.region
  tags                                  = var.tags
}


/*-----------------------------------------------------------------------------8
|                                                                              |
|                                STORAGE ACCOUNT                               |
|                                                                              |
+--------------------------------------4--------------------------------------*/
resource random_id library {
  byte_length                           = 8
}


/*-----------------------------------------------------------------------------8
|                                                                              |
|                                STORAGE ACCOUNT                               |
|                                                                              |
+--------------------------------------4--------------------------------------*/
resource  azurerm_storage_account library {
  # Naming Standard:  {deployzone}{region_map}library
  name                                  = "${lower(lookup(var.deployZoneMap, var.deployZone, "unknown"))}${
                                             lower(lookup(var.regionMap, var.region, "unknown"))}lib${
                                             lower(random_id.library.hex)}"


  resource_group_name                   = azurerm_resource_group.library.name
  location                              = azurerm_resource_group.library.location
  tags                                  = var.tags
  account_kind                          = "Storage"
  account_tier                          = "Standard"
  account_replication_type              = "LRS"
  network_rules {
    default_action                      = "Allow"
  }
}


/*-----------------------------------------------------------------------------8
|                                                                              |
|                                  CONTAINER                                   |
|                                                                              |
+--------------------------------------4--------------------------------------*/
resource  azurerm_storage_container sapbits {
  name                                  = "sapbits"
  storage_account_name                  = azurerm_storage_account.library.name
  container_access_type                 = "private"
}


# TODO: private endpoint (To be created by sap VNET code)

