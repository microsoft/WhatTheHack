provider "azurerm" {
  version = ">=1.20"
}

data "azurerm_log_analytics_workspace" "aksmon" {
  name                = "${var.la_workspace_name}"
  resource_group_name = "${var.la_resource_group}"
}

resource "azurerm_log_analytics_solution" "containerInsights" {
  solution_name         = "ContainerInsights"
  location              = "${data.azurerm_log_analytics_workspace.aksmon.location}"
  resource_group_name   = "${data.azurerm_log_analytics_workspace.aksmon.resource_group_name}"
  workspace_resource_id = "${data.azurerm_log_analytics_workspace.aksmon.id}"
  workspace_name        = "${data.azurerm_log_analytics_workspace.aksmon.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  lifecycle {
    prevent_destroy = true
  }
}
