# Challenge 03 - Create the Realtime Reporting

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)**

## Pre-requisites

- Stock Table in the KQLDB
- KQL Queryset with transformations 

## Description

You've been tasked with creating some real time reporting using Power BI based on the data that is constantly being generated every second. In this challenge, you must bring in the data from the KQL database/queryset to PowerBI. You need to create visualizations that represent the incoming data, but you will also need to modify some settings to ensure that this is truly real-time reporting. 

## Success Criteria

To complete this challenge, verify that:
- You have a PowerBI report displaying the data from the Stock table.
    - Line Graph showing the previous minute of data of each stocks price
- Your report page is auto-refreshing every second with the data your KQL DB is ingesting continuously.

## Learning Resources
- [Power BI Realtime Settings](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-automatic-page-refresh)
- [Creating a real-time dataset in the Fabric portal](https://learn.microsoft.com/en-us/fabric/real-time-analytics/create-powerbi-report)
- [Creating a real-time dataset in Power BI Desktop](https://learn.microsoft.com/en-us/fabric/real-time-analytics/power-bi-data-connector)

## Tips
- Use a Card that has the count of the number of records to help ensure data is being constantly updated in the report.
- To get to the Fabric capacity settings you can go to the `Admin Portal` in Power BI and then on the far right click on `Fabric Capacity`. In there the `Automatic page refresh` setting should be under `Power BI Workloads`
- To create the settings for realtime reporting, make sure you are clicked off of any visuals so that the page settings show up.
- It is easier to save the report in the popout from the KQL Queryset, then open it in the proper editor in the browser, rather than in the small popout from the KQL Queryset option.
<!-- far easier to do the creating the dataset in the portal than PBI Desktop, but that tip may be giving too much away -->

## Additional Challenges
- Get creative with the Power BI report! What kind of visuals can you create?
