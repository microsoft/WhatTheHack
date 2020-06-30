data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "main" {
  name = "kv-${lower(
    replace(
      replace(timestamp(), local.colon, local.empty_string),
      local.dash,
      local.empty_string,
    ),
  )}"
  count               = var.windows_bastion ? 1 : 0
  location            = var.az_region
  resource_group_name = var.az_resource_group
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enabled_for_deployment          = true
  enabled_for_template_deployment = true

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.service_principal_object_id

    certificate_permissions = [
      "create",
      "delete",
      "get",
      "update",
    ]

    key_permissions    = []
    secret_permissions = []
  }

  tags = {
    bastion-key-vault = ""
  }
}

resource "azurerm_key_vault_certificate" "main" {
  name      = "${local.machine_name}-cert"
  count     = var.windows_bastion ? 1 : 0
  vault_uri = azurerm_key_vault.main[0].vault_uri

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=${local.machine_name}"
      validity_in_months = 12
    }
  }
}

