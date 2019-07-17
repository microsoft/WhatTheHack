# Optional Challenge B - Data in Cosmos DB

### Help references

|                       |                                                           |
| --------------------- | :-------------------------------------------------------: |
| **Description**       |                         **Links**                         |
| About Azure Cosmos DB | <https://docs.microsoft.com/azure/cosmos-db/introduction> |

### Task 1: Use the Azure Cosmos DB Data Explorer

1.  Open your Azure Cosmos DB account by opening the **ServerlessArchitecture** resource group, and then selecting the **Azure Cosmos DB account** name.

2.  Select **Data Explorer** from the menu.

    ![In the Tollbooth - Data Explorer blade, Data Explorer is selected.](../images/image75.png 'Tollbooth - Data Explorer blade')

3.  Expand the **Processed** collection, then select **Documents**. This will list each of the JSON documents added to the collection.

4.  Select one of the documents to view its contents. The first four properties are ones that were added by your functions. The remaining properties are standard and are assigned by Cosmos DB.

    ![Under Collections, Processed is expanded, and Documents is selected. On the Documents tab, a document is selected, and to the side, the first four properties of the document (fileName, licencePlateText, timeStamp, and exported) are circled.](../images/image76.png 'Tollbooth - Data Explorer blade')

5.  Expand the **NeedsManualReview** collection, then select **Documents**.

6.  Select one of the documents to view its contents. Notice that the filename is provided, as well as a property named "resolved". While this is out of scope for this lab, those properties can be used together to provide a manual process for viewing the photo and entering the license plate.

    ![Under Collections, NeedsManualReview is expanded, and Documents is selected. On the Documents tab, a document is selected, and to the side, the first four properties of the document (fileName, licencePlateText, timeStamp, and resolved) are circled.](../images/image77.png 'Tollbooth - Data Explorer blade')

7.  Right-click on the **Processed** collection and select **New SQL Query**.

    ![Under Collections, LicencePlates is expanded, and Processed is selected. From its right-click menu, New SQL Query is selected.](../images/image78.png 'Tollbooth - Data Explorer blade')

8.  Modify the SQL query to count the number of processed documents that have not been exported:

```sql
SELECT VALUE COUNT(c.id) FROM c WHERE c.exported = false
```

9.  Execute the query and observe the results. In our case, we have 1,369 processed documents that need to be exported.

    ![On the Query 1 tab, under Execute Query, the previously defined SQL query displays. Under Results, the number 1369 is highlighted.](../images/cosmos-query-results.png 'Query 1 tab')


[Next challenge (Data Export Workflow) >](./Host-Workflow.md)
