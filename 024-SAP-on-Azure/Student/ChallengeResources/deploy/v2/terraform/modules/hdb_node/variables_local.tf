variable "resource-group" {
  description = "Details of the resource group"
}

variable "subnet-sap-admin" {
  description = "Details of the SAP admin subnet"
}

variable "subnet-sap-db" {
  description = "Details of the SAP DB subnet"
}

variable "nsg-admin" {
  description = "Details of the SAP admin subnet NSG"
}

variable "nsg-db" {
  description = "Details of the SAP DB subnet NSG"
}

variable "storage-bootdiag" {
  description = "Details of the boot diagnostics storage account"
}

# Imports HANA database sizing information
locals {
  sizes = jsondecode(file("${path.root}/../hdb_sizes.json"))
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

  # Ports used for specific HANA Versions
  lb_ports = {
    "1" = [
      "30015",
      "30017",
    ]

    "2" = [
      "30013",
      "30014",
      "30015",
      "30040",
      "30041",
      "30042",
    ]
  }

  # Hash of Load Balancers to create for HANA instances
  loadbalancers = zipmap(
    range(
      length([
        for database in local.hana-databases : database.instance.sid
      ])
    ),
    [
      for database in local.hana-databases : {
        sid             = database.instance.sid
        instance_number = database.instance.instance_number
        ports = [
          for port in local.lb_ports[split(".", database.db_version)[0]] : tonumber(port) + (tonumber(database.instance.instance_number) * 100)
        ]
        frontend_ip = lookup(lookup(database, "loadbalancer", {}), "frontend_ip", false),
      }
    ]
  )

  # List of ports for load balancer
  loadbalancers-ports = length(local.loadbalancers) > 0 ? local.loadbalancers[0].ports : []
}

# List of data disks to be created for HANA DB nodes
locals {
  data-disk-per-dbnode = flatten(
    length(local.dbnodes) > 0 ?
    [
      for storage_type in lookup(local.sizes, local.dbnodes[0].size).storage : [
        for disk_count in range(storage_type.count) : {
          name                      = join("-", [storage_type.name, disk_count])
          storage_account_type      = storage_type.disk_type,
          disk_size_gb              = storage_type.size_gb,
          caching                   = storage_type.caching,
          write_accelerator_enabled = storage_type.write_accelerator
        }
      ]
      if storage_type.name != "os"
  ] : [])

  data-disk-list = flatten([
    for dbnode in local.dbnodes : [
      for datadisk in local.data-disk-per-dbnode : {
        name                      = join("-", [dbnode.name, datadisk.name])
        caching                   = datadisk.caching
        storage_account_type      = datadisk.storage_account_type
        disk_size_gb              = datadisk.disk_size_gb
        write_accelerator_enabled = datadisk.write_accelerator_enabled
      }
    ]
  ])
}
