resource "datadog_monitor" "VMDown" {
  name               = "Azure VM Down"
  type               = "event-v2 alert"
  message            = "Monitor triggered. Notify: @teams-channel"
  escalation_message = "Escalation message @teams-warroom"

  query = "avg(last_1h):avg:azure.vm.cpu{environment:dev} by {host} < 1"

  monitor_thresholds {
    warning  = 1
    critical = 2
  }

  include_tags = true

  tags = ["env:dev", "service:WhatTheHack", "team:PlatformEng"]
}
