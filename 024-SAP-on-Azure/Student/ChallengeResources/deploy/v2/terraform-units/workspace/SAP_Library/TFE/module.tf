/*-----------------------------------------------------------------------------8
|                                                                              |
|                                    MODULE                                    |
|                                                                              |
+--------------------------------------4--------------------------------------*/
module "sap_library" {
  source                                = "../../../modules/sap_library"
  deployZone                            = var.deployZone
  region                                = var.region
  tags                                  = var.tags
}
