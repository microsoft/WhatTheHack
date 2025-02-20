# Challenge 05 - Visualize predictions with a Power BI report

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

During Challenge 4, you generated batch predictions over simulated patient data. This reflects the scenario of receiving new data of patients that are currently being monitored. You must now display the predictions in an insightful way that can show doctors which patients are at risk. To do so, you will be building a PowerBI report using the newly created predictions.

## Description

You've been tasked with creating some reporting using Power BI based on the data which got batch predicted and saved to a delta table in the last challenge. In this challenge, you must create a semantic model and the report and visualizations based on it. You will need to explore working on PowerBI to build the most helpful report you can based on the available data. This challenge does **not** require the use of a notebook. 

By the end of this challenge, you should be able to understand and know how to use:
- Fabric Semantic Models, how do you create one from existing data and what you can use it for.
- PowerBI basic reporting, how do you build a report from a semantic model and how different PowerBI visualizations can convey insights.

## Success Criteria

To complete this challenge, verify that:

- You have a PowerBI report displaying the data from the batch predicted table. Your report must, at a minimum, be able to identify which patients are at risk of heart failure. You must use the id field for this purpose.

## Learning Resources

- [How to create  semantic model in Fabric](https://microsoftlearning.github.io/mslearn-fabric/Instructions/Labs/14-create-a-star-schema-model.html)
- [How to create reports in Fabric](https://learn.microsoft.com/en-us/fabric/data-engineering/tutorial-lakehouse-build-report)

## Tips

- If you are unable to create a semantic model with your table, delete the delta table and re-run Notebook 3. Unfortunately, this is a [known issue](https://learn.microsoft.com/en-us/fabric/get-started/known-issues/known-issue-643-tables-not-available-semantic-model).
- PowerBI auto-aggregates data fields. Sometimes, you want different aggregations than the default or no aggregations at all.
- The way you organize data fields when building a PowerBI visualization affects the end result. Use the Data field to shape your visualization.
- PowerBI visualizations have extensive formatting options. Even the more traditional options can be enhanced with features such as conditional color.

## Advanced Challenges (Optional)

Get creative with the Power BI report! What kind of visuals can you create?

There is a variety of data within the table that you saved in the previous challenge and PowerBI offers you many ways to show it. Explore the different options, including the [AI Visuals](https://learn.microsoft.com/en-us/power-bi/visuals/power-bi-visualization-decomposition-tree) (link redirects to decomposition tree, but feel free to explore the whole learn page) and try to build a report that conveys improved insights. 
