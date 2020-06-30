variable "is_single_node_hana" {
  description = "Checks if single node hana architecture scenario is being deployed"
  default     = false
}

locals {

  # Filter the list of databases to only HANA platform entries
  hana-databases = [
    for database in var.databases : database
    if database.platform == "HANA"
  ]

  # Numerically indexed Hash of HANA DB nodes to be created
  dbnodes = flatten([
    [
      for database in local.hana-databases : [
        for dbnode in database.dbnodes : {
          platform       = database.platform,
          name           = "${dbnode.name}-0",
          admin_nic_ip   = lookup(dbnode, "admin_nic_ips", [false, false])[0],
          db_nic_ip      = lookup(dbnode, "db_nic_ips", [false, false])[0],
          size           = database.size,
          os             = database.os,
          authentication = database.authentication
          sid            = database.instance.sid
        }
      ]
    ],
    [
      for database in local.hana-databases : [
        for dbnode in database.dbnodes : {
          platform       = database.platform,
          name           = "${dbnode.name}-1",
          admin_nic_ip   = lookup(dbnode, "admin_nic_ips", [false, false])[1],
          db_nic_ip      = lookup(dbnode, "db_nic_ips", [false, false])[1],
          size           = database.size,
          os             = database.os,
          authentication = database.authentication
          sid            = database.instance.sid
        }
      ]
      if database.high_availability
    ]
  ])

  # iSCSI target device(s) is only created when below conditions met:
  # - iscsi is defined in input JSON
  # - AND
  #   - HANA database has high_availability set to true
  #   - HANA database uses SUSE
  iscsi_count = lookup(var.infrastructure, "iscsi", {}) != {} && (length(local.hana-databases) > 0 ? (local.hana-databases[0].high_availability && upper(local.hana-databases[0].os.publisher) == "SUSE") : false) ? var.infrastructure.iscsi.iscsi_count : 0

  # Shortcut to iSCSI definition
  iscsi = merge(lookup(var.infrastructure, "iscsi", {}), { "iscsi_count" = "${local.iscsi_count}" })
}
