# Challenge 05 - Visualize predictions with a Power BI report - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Setup Steps

- Create Semantic model
-  Create PBI report


## Notes and Guidance
This challenge completes the hack by setting up a PowerBI report that shows the batch preditiction data predicted by the trained model.

- Creating the Semantic model: The easiest way to do so is from the Batch Prediction table stored in Lakehouse in Challenege 4:

  - Navigate to the batch prediction table made in the previous challenge by going to the lakehouse where it got stored.
  - On the Lakehouse, create a semantic model required to build Power BI Report. Use the top ribbon on the lakehouse explorer and click on **New semantic model**.
  - During semantic model creation, provide semantic model name, chose workspace (you can use the same one which we have been using for the lakehouse and notebooks) where you want to store the semantic model and select the **heartFailure_pred** table and click the confirm button to create the semantic model.
  - It will take you to the semantic model page, on the top of the page, use the ribbon to click on the **New Report** button to create the PowerBI report.
    
 
- Create the Power BI report.
  -  Navigate to the **Visualizations** pane on the right side of your screen. From the group of icons, find the **Table** visual (on the 4th row) and click on it. 
  -  Create a Table with the following settings:
    - Data Values: on the **Columns** field of the Visualizations pane, drag and drop the **ID**, **age** and **predictions**  columns from the **heartFailure_pred** table located in the **Data** pane to the rightmost of your screen. Click on the dropdown arrow next to the table name to access the columns.
    - Make sure select the "Do not summarize" for all the columns. Once you place the columns in the Visualizations pane, use the dropdown arrow next to each column to select **Don't summarize**
    - For prediction column, select the conditional formatting from the predicton column by clicking again on the dropdown arrow next to the column name under the data values field in visualization pane. Choose **Background color** from the list of options.
    - Set the format style to **Rules**. Create 2 rules: if value equals to "0", show background color blue and if value equals to "1" show background color red. Click on **Ok** to close the window.
  - This is the most basic visualization that student should create to identify patients at risk of heart failure. Students are encourage in the challenge to create a variety of visualizations to explore other insights, such as how Age or Sex influence the chance of being at risk or how many total patients are at risk.
  - This challenge can also be used to explore PowerBI report formatting.
