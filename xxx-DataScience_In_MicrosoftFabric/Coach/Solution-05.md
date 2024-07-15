# Challenge 05 - Visualize predictions with a Power BI report - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Setup Steps

- Create Semantic model
-  Create PBI report


## Notes and Guidance
This challenge completes the hack by setting up a PowerBI report that shows the batch preditiction data predicted by the trainde model.

- Creating the PowerBI report: The easiest way to do so is from the Batch Prediction table stored in Lakehouse in Challenege 4:

  - Navigate to the bacth prediction table made in the previous challenge
  - On the Lakehouse, create semantic model select Build Power BI Report
The report can be saved in the following pop-up, or edited in full screen after being saved. The one requirement before exiting out of this pop-up is to click on the top right "File" dropdown menu and select "Save". The student should create the required visuals as per the challenge.
Give the report a name and place it in workspace (it is recommended to be the same one that already contains the KQL database)
Adjusting the page refresh settings (admin):

On the right hand side of Fabric's top navigation bar, select the settings icon.
Navigate to the Admin portal -> Capacity settings -> Trial/Fabric Capacity (if the student has purchased a Fabric capacity, it will be in the second option. If it is a free trial, it will be on the first one)
Click on the name of the capacity in use and NOT on the "Actions" settings icon
From the PowerBI Workloads menu in the following screen, turn on Automatic Page Refresh and set a Minimum Refresh Interval of 1 second.
Adjusting the page refresh settings (report):

Open the report from the workspace
From the top navigation bar, select "Edit"
On the second group of tabs, Visualizations, on the right side of the screen, click on the Page Format icon (paintbrush with sheet of paper)
At the bottom of those options, open the Page refresh dropdown and enter your desired page refresh interval (1 second)
Click on "show details" to check how often the report page is refreshing
Create the graph

Create a line graph with the following settings:
Legend: Stock Symbol
X-axis: Timestamp
Y-axis: Stock Price
Edit the filters on the visual so it only displays the previous one minute of information
