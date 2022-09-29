terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {
  api_key = "" # Replace this with API key from https://us3.datadoghq.com/organization-settings/api-keys
  app_key = "" # New App key can be made here: https://us3.datadoghq.com/organization-settings/application-keys
  api_url = "https://us3.datadoghq.com" # We're using US3 with Azure
}

resource "datadog_monitor" "VM_CPU" {
  name               = "Azure VM CPU Above 40%"
  type               = "metric alert"
  message            = "Monitor triggered. Notify: @teams-channel"
  escalation_message = "Escalation message @teams-channel"

  query = "avg(last_1h):avg:azure.vm.percentage_cpu{host:vmwthdbdeu} by {host} > 90"

  monitor_thresholds {
    warning  = 80
    critical = 90
  }

  include_tags = true

  tags = ["cloud:azure", "team:platform"]
}
