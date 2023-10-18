# Challenge 08 - Azure Monitoring: Application Insights

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-09.md)

## Introduction

To bring our DevOps journey full circle we need to understand what is happening in our deployed sites. It is too late for us to find out about a problem, by the time our users are complaining about it. It is also imperative to know about not only the performance of the site, but also the impact positive or negative a feature has had on our users. Please take a moment to review the articles below to gain a better understanding of the importance of monitoring and Application Insights, one of the tools we have to make it easy in Azure. 

1. [What is Monitoring?](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-monitoring)
2. [What is Application Insights?](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)

## Description

In this challenge we will look at some of the telemetry that has already been collected by our running instance. We will also link Application Insights to Azure DevOps. This will allow us to open work items in Azure Boards directly from Application Insights, ensuring that there is full traceability between the issue that happened and all the technical information about it to the work item that was created to ask the dev team to fix it, to the code that fixed the issue, to the build and release that saw that fix get deployed. 

- Review the `container-webapp-template.json` ARM template. Find where the Application Insights node was created and note how it the App Service Web Site was configured to send its logs there. 
- Implement an outside in availability test for the homepage of your site ([Hint](https://docs.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability))
- Create a dashboard in the Azure Portal to provide a summary of the status of our site. ([Hint](https://docs.microsoft.com/en-us/azure/azure-monitor/app/overview-dashboard#application-dashboard))
- Link your Application Insights instance with your Azure Boards instance ([Hint](https://azure.microsoft.com/en-us/blog/application-insights-work-item-integration-with-visual-studio-team-services/))
- Using the availability feature of Application Insights traverse to an end-to-end transaction for your site. You should be able to create a work item for that transaction.  

## Success Criteria

1. You should understand the importance of monitoring, some of the basic features offered by Application Insights, and the integration between Application Insights and Azure DevOps.
    > NOTE: We are just scratching the surface of what is offered in Azure Monitoring, if you are interested in learning more there is a full What the Hack focused on Azure Monitoring.

### Learning Resources

1. [Azure DevOps Work Item Integration](https://learn.microsoft.com/en-us/azure/azure-monitor/app/work-item-integration)