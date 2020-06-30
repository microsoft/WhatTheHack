/*
                      /////// \\\\\\\
                ///////             \\\\\\\
         ////////                         \\\\\\\
   ///////                                      \\\\\\\
  (((((((   CAUTION:  GLOBALLY MAINTAINED FILE   )))))))
   \\\\\\\                                      ///////
         \\\\\\\                          ///////
               \\\\\\\              ///////
                     \\\\\\\  ///////
*/

# TODO: subscription map
# TODO: region map
# TODO: tags map

variable deployZone {
  type        = string
  description = "PUB (Public), PROTO (Prototype), NP (Non-Prod), PROD (Production)"
  default     = "NOT_SET"
}

variable region {
  type        = string
  description = "Region"
  default     = "NOT_SET"
}


/*-----------------------------------------------------------------------------8
|                                                                              |
|                                   MAPPINGS                                   |
|                                                                              |
+--------------------------------------4--------------------------------------*/
variable tags {
  type        = map(string)
  description = "Tags for Resources"
  default = {
    Workload                              = "SAP"
    Deployment                            = "SAP on Azure Automation"
    OwnerAlias                            = "NOT_SET"
  }
}

variable "regionMap" {
  type        = map(string)
  description = "Region Mapping: Full = Single CHAR, 4-CHAR"

  # 28 Regions
  default = {
    westus              = "weus"
    westus2             = "wus2"
    centralus           = "ceus"
    eastus              = "eaus"
    eastus2             = "eus2"
    northcentralus      = "ncus"
    southcentralus      = "scus"
    westcentralus       = "wcus"
    northeurope         = "noeu"
    westeurope          = "weeu"
    eastasia            = "eaas"
    southeastasia       = "seas"
    brazilsouth         = "brso"
    japaneast           = "jpea"
    japanwest           = "jpwe"
    centralindia        = "cein"
    southindia          = "soin"
    westindia           = "wein"
    uksouth2            = "uks2"
    uknorth             = "ukno"
    canadacentral       = "cace"
    canadaeast          = "caea"
    australiaeast       = "auea"
    australiasoutheast  = "ause"
    uksouth             = "ukso"
    ukwest              = "ukwe"
    koreacentral        = "koce"
    koreasouth          = "koso"
  }
}

variable deployZoneMap {
  type        = map(string)
  description = "PUB (Public), PROTO (Prototype), NP (Non-Prod), PROD (Production)"
  default     = {
    PUB                 = "Z"
    PROTO               = "X"
    NP                  = "N"
    PROD                = "P"
  }
}
