# Challenge 05 - Add Application Monitoring

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

We've got our app running, but how do we know how well it's performing? Let's instrument `Application Insights` so you can see what's happening inside the app.

![Add Application Monitoring](../docs/AddApplicationMonitoring.png)

## Description

- You'll find the app is already wired up for Application Insights, you just need to populate app settings configuration with your own Application Insights key. Once you have the key, start using the app to see metrics.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Make sure you got some data in Application Insights while running your application in both places locally and in Azure App Service. Make sure you are leveraging the proper way for both to set the `InstrumentationKey` (i.e. in `docker-compose.yaml` file for local and in Azure App Service's `AppSettings`).
- Build a dashboard in the Azure Portal for viewing performance of the app.
- In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Learning Resources

1. [What is Application Insights?](https://docs.microsoft.com/en-us/azure/application-insights/app-insights-overview)

## Tips

1. Game Duration is a Custom Metric, you should see it populate in the Visualization builder after you run a game.
