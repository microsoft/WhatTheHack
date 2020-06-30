##################################################################################################################
# OUTPUT Files
##################################################################################################################

# Generates the output JSON with IP address and disk details
resource "local_file" "output-json" {
  content = jsonencode({
    "infrastructure" = merge(var.infrastructure, { "iscsi" = { "iscsi_nic_ips" = [local.ips-iscsi] } })
    "jumpboxes" = {
      "windows" = [for jumpbox-windows in var.jumpboxes.windows : {
        name                 = jumpbox-windows.name,
        destroy_after_deploy = jumpbox-windows.destroy_after_deploy,
        size                 = jumpbox-windows.size,
        disk_type            = jumpbox-windows.disk_type,
        os                   = jumpbox-windows.os,
        authentication       = jumpbox-windows.authentication,
        components           = jumpbox-windows.components,
        private_ip_address   = local.ips-jumpboxes-windows[index(var.jumpboxes.windows, jumpbox-windows)]
        public_ip_address    = local.public-ips-jumpboxes-windows[index(var.jumpboxes.windows, jumpbox-windows)]
        }
      ],
      "linux" = [for jumpbox-linux in var.jumpboxes-linux : {
        name                 = jumpbox-linux.name,
        destroy_after_deploy = jumpbox-linux.destroy_after_deploy,
        size                 = jumpbox-linux.size,
        disk_type            = jumpbox-linux.disk_type,
        os                   = jumpbox-linux.os,
        authentication       = jumpbox-linux.authentication,
        components           = jumpbox-linux.components,
        private_ip_address   = local.ips-jumpboxes-linux[index(var.jumpboxes-linux, jumpbox-linux)]
        public_ip_address    = local.public-ips-jumpboxes-linux[index(var.jumpboxes-linux, jumpbox-linux)]
        }
      ]
    },
    "databases" = [for database in var.databases : {
      platform          = database.platform,
      db_version        = database.db_version,
      os                = database.os,
      size              = database.size,
      filesystem        = database.filesystem,
      high_availability = database.high_availability,
      instance          = database.instance,
      authentication    = database.authentication,
      credentials       = database.credentials,
      components        = database.components,
      xsa               = database.xsa,
      shine             = database.shine,
      nodes = [for ip-dbnode-admin in local.ips-dbnodes-admin : {
        dbname       = local.dbnodes[index(local.ips-dbnodes-admin, ip-dbnode-admin)].name
        ip_admin_nic = ip-dbnode-admin,
        ip_db_nic    = local.ips-dbnodes-db[index(local.ips-dbnodes-admin, ip-dbnode-admin)],
        role         = local.dbnodes[index(local.ips-dbnodes-admin, ip-dbnode-admin)].role
        } if local.dbnodes[index(local.ips-dbnodes-admin, ip-dbnode-admin)].platform == database.platform
      ],
      loadbalancer = {
        frontend_ip = var.loadbalancers[index(var.databases, database)].private_ip_address
      }
      }
    ],
    "software" = {
      "storage_account_sapbits" = {
        "name"                = var.storage-sapbits[0].name,
        "storage_access_key"  = var.storage-sapbits[0].primary_access_key,
        "blob_container_name" = lookup(var.software.storage_account_sapbits, "blob_container_name", null)
        "file_share_name"     = lookup(var.software.storage_account_sapbits, "file_share_name", null)
      },
      "downloader" = var.software.downloader
    }
    "options" = var.options
    }
  )
  filename = "${path.root}/../ansible_config_files/output.json"
}

# Generates the Ansible Inventory file
resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/ansible_inventory.tmpl", {
    iscsi                 = lookup(var.infrastructure, "iscsi", {}),
    jumpboxes-windows     = var.jumpboxes.windows,
    jumpboxes-linux       = var.jumpboxes-linux,
    ips-iscsi             = local.ips-iscsi,
    ips-jumpboxes-windows = local.ips-jumpboxes-windows,
    ips-jumpboxes-linux   = local.ips-jumpboxes-linux,
    ips-dbnodes-admin     = local.ips-dbnodes-admin,
    ips-dbnodes-db        = local.ips-dbnodes-db,
    dbnodes               = local.dbnodes
    }
  )
  filename = "${path.root}/../ansible_config_files/hosts"
}
