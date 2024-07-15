# Challenge 05 - Visualize predictions with a Power BI report - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Setup Steps

- Create Semantic model
-  Create PBI report


## Notes and Guidance
This challenge completes the hack by setting up a PowerBI report that shows the batch preditiction data predicted by the trained model.

- Creating the Semantic model: The easiest way to do so is from the Batch Prediction table stored in Lakehouse in Challenege 4:

  - Navigate to the batch prediction table made in the previous challenge by going to the lakehouse hwere it got stored.
  - On the Lakehouse, create semantic model required to build Power BI Report
  - During semantic model creation, provide semantic model name, choose worksspace where you want to store the semantic model and select the batch predicted table and click the confirm button to create the semantic model.
  - It will take you to semantic model page, on the top of the page, click on the new report to create the power Bi report.
    
 
- Create the Power BI report.
  -  Create a Table with the following settings:
    - Data Values: ID, predictions and age column from the table 
    - Make sure select the "Do not summarize" for all the columns.
    - for prediction column, select the conditional formatting from the  predicton column under  data value in visualization pane.
    - Set the rules for "0" value to show background color blue and for "1" value to show background color red 

