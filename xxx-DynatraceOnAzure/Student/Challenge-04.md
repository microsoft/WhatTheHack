# Challenge 04 - Custom Dashboard and SLO setup

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)



## Pre-requisites (Optional)
None

## Introduction

In order to do more with less and scale, organizations must transcend IT silos, foster collaboration and improve productivity. Automation and a common data model are key components of this, but it takes platforms that support operational teams and workflows.

Referring to the picture below, here are the components for this lab.

![](images/challenge4-azuremonitor-setup.png )

#1 . Azure: Azure cloud platform where Azure services produce metrics that are sent to Azure monitor.

#2 . Azure VM running ActiveGate: A Dynatrace ActiveGate process required to monitor Azure monitor data.

#3 . Dynatrace: Dynatrace tenant where monitoring data is collected and analyzed.

#4 . Dynatrace Azure Dashboard: Out of the box dashboard for each configured Azure subscription.

## Description

### Objectives of this Challenge
🔷 Review how Dynatrace integrates with [Azure monitor](https://www.dynatrace.com/support/help/how-to-use-dynatrace/infrastructure-monitoring/cloud-platform-monitoring/microsoft-azure-services-monitoring/set-up-azure-monitoring)

🔷 Review how Azure monitor metrics can be configured as [Metric events for alerts](https://www.dynatrace.com/support/help/how-to-use-dynatrace/problem-detection-and-analysis/problem-detection/metric-events-for-alerting/)

🔷 Examine Dynatrace Service Level Objectives (SLOs)

🔷 Create a custom dashboard with SLOs

### Tasks

- Review the Azure screen in your enviornment
    - From the left side menu in Dynatrace, click the Azure menu item.
    - Scroll down, and in the Environment dynamics action click on the region to open the virtual machine regional page
- Create an SLO Dashboard and call it "Cloud Migration Sucess"
    - From the left side menu in Dynatrace, pick the dashboard menu.
    - On the dashboard page, click the new dashboard button. Give the dashboard a name of "Cloud Migraton Sucess"
    - On the blank dashboard page, click the settings. Then click the advanced settings link to open then settings page
    - On the settings page, click the dashboard JSON menu.
    - Copy and paste the following Json content from this file into your dashboard JSON, replacing the existing JSON in the process: [Dashboard JSON file Link](https://raw.githubusercontent.com/dt-alliances-workshops/azure-modernization-dt-orders-setup/master/learner-scripts/cloud-modernization-dashboard.json)
        - **Note:** You MUST replace the owner field to be the email that you logged into Dynatrace with or you will not be able to view it.
    - After you edit the email, then click the Revert Dashboard ID button. After you click the Revert Dashboard ID button, click the Save changes button.
- View the dashboard
    ![](images/challenge4-slo-dashboard-init.png)
- Edit the dashboard and adjust the tiles with the SLOs and databases in your environment. Repeat the same steps above for the Cloud services tile, but pick the staging- frontend in the Service properties window


## Success Criteria

- Cloud Migration dashboard shows SLO data for frontend service on monolith and kubernetes
- Azure dashboard under Infrastructure -> Azure shows Azure monitor metrics.

## Learning Resources
 - [Monitor Azure Services with Azure Monitor Metrics](https://www.dynatrace.com/support/help/setup-and-configuration/setup-on-cloud-platforms/microsoft-azure-services/azure-integrations/azure-monitoring-guide)
 - [Azure Cloud Services enabled with Azure monitor integration](https://www.dynatrace.com/support/help/setup-and-configuration/setup-on-cloud-platforms/microsoft-azure-services/azure-integrations/azure-cloud-services-metrics)
 - [Default Azure Metrics enabled](https://www.dynatrace.com/support/help/setup-and-configuration/setup-on-cloud-platforms/microsoft-azure-services/azure-integrations/azure-monitoring-guide/azure-metrics)
 - [Instructions to create dashboards are located here](https://www.dynatrace.com/support/help/how-to-use-dynatrace/dashboards-and-charts/dashboards/create-dashboards)


## Tips



## Advanced Challenges (Optional)


Too comfortable?  Eager to do more?  Try these additional challenges!

- Observe what happens if your IoTDevice is separated from its thingamajig.
- Configure your IoTDevice to connect to BOTH the mothership and IoTQueenBee at the same time.
