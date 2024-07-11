# Challenge 05 - Grail - Dashboards & Notebooks  - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

## Detailed Steps

### Dashboards
* Open the Dashboards app from the Left Menu
* Select + Dashboard
* Select + to add dashboard element
* Select Query Grail

![image](Solutions/img/challenge5-01.png)

* In the tile editor for Query, enter the following DQL
```bash
    fetch logs
    | filter cloud.provider == "azure"
    | summarize count(), by:{azure.resource.type}
    | sort `count()`, direction:"descending"
```
* Select Run Query. For logs, your results will be generated in a table by default.
* Select Select visualization tab to display the results differently. image
![image](Solutions/img/challenge5-02.gif)

### Notebooks to analyze log data

* Download this sample notebook we will use to analyze logs
    - Right click in browser, click Save As
    - Click on [this link](https://raw.githubusercontent.com/dt-alliances-workshops/azure-modernization-dt-orders-setup/grail/learner-scripts/AzureGrailWorkshop-Logs.json) to download the file.
        ![image](Solutions/img/challenge5-03.png)
* Go into Dynatrace UI, open the notebooks app from your left menu
    ![image](Solutions/img/challenge5-04.png)
* Expand the Notebooks menu
    ![image](Solutions/img/challenge5-05.png)
* Click on upload and browse to the notebook JSON file where you saved.
* Follow the instructions in the notebook to analyze log data from a Hipster shop sample app.

### Notebooks to analyze metric data
* Download this sample notebook we will use to analyze logs
    - Right click in browser, click Save As
    - Click on [this link](https://raw.githubusercontent.com/dt-alliances-workshops/azure-modernization-dt-orders-setup/grail/learner-scripts/AzureGrailWorkshop-Metrics.json) to download the file.
        ![image](Solutions/img/challenge5-03.png)
* Go into Dynatrace UI, open the notebooks app from your left menu
    ![image](Solutions/img/challenge5-04.png)
* Expand the Notebooks menu
    ![image](Solutions/img/challenge5-05.png)
* Click on upload and browse to the notebook JSON file for Metrics where you saved.
* Follow the instructions in the notebook to analyze Azure  metrics for your hosts.