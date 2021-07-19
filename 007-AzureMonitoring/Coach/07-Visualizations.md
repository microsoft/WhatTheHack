# Challenge 7: Visualizations

[Previous Challenge](./06-Log-Queries-With-KQL-And-Grafana.md) - **[Home](../README.md)**

## Notes & Guidance

- Navigate to your Application Insights resource in the Portal
- Click on Workbooks New

![](../images/image145.png)

- Click Empty then click "+Add" in the New Workbook section to add text describing the upcoming content in the workbook. Text is edited using Markdown syntax.

>**Tip:** You can add here the text of our Challenge (Objectives, Tasks ..etc)
  
- Click done editing to see how it looks, if it looks bad you can use an online Text to Markup converter.
  
>**Tips:**
Use **Add text** to describe the upcoming table
Use **Add parameters** to create the time selector
Use **Add query** to retrieve data from pageViews
Use **Column Settings** to change labels of column headers and use Bar and Threshold visualizations.

Add the following time parameter:
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image146.png)  
- And the following Query: (Browser Statistics)  
```
pageViews
| summarize pageSamples = count(itemCount), pageTimeAvg = avg(duration), pageTimeMax = max(duration) by name
| sort by pageSamples desc
```    
- And the following Query: (Request Failures)  
```
requests
| where success == false
| summarize total_count=sum(itemCount), pageDurationAvg=avg(duration) by name, resultCode
```

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image148.png)
- You can also add a Metric to create a metric chart, add the server response time.

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image148_2.png)
  
Should look something like that:
  
![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image148_3.png)

- Add another query to show the CPU Usage but change your **Resource Type** to Virtual Machines  

>**Tip:** Make use of the sample queries in the Log Analytics Workspace

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image149.png)  
- Add another query, change the Resource Type to Log Analytics
- Change your workspace to the LA workspace with your AKS container logs
 
Add this query which is used for section Disk Used Percentage
```
InsightsMetrics
| where Namespace == "container.azm.ms/disk" 
| where Name == "used_percent"
| project TimeGenerated, Computer, Val 
| summarize avg(Val) by Computer, bin(TimeGenerated, 1m)
| render timechart
```
  

Should look like that:

![](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/image150.png)
 

- Save your workbook.

Great work ;-) you have finished!


## Learning Resources
* [Azure Monitor Workbooks](https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-workbooks)
