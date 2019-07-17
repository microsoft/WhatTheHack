# Challenge 7 - Data Export Workflow


|                                      |                                                                                                                 |
| ------------------------------------ | :-------------------------------------------------------------------------------------------------------------: |
| **Description**                      |                                                    **Links**                                                    |
| What are Logic Apps?                 |                  <https://docs.microsoft.com/azure/logic-apps/logic-apps-what-are-logic-apps>                   |
| Call Azure Functions from logic apps | <https://docs.microsoft.com/azure/logic-apps/logic-apps-azure-functions%23call-azure-functions-from-logic-apps> |
|                                      |                                                                                                                 |
### Task 1: Create the Logic App

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then enter **logic app** into the search box on top. Select **Logic App** from the results.

    ![In the Azure Portal, in the menu, New is selected. In the New blade, logic ap is typed in the search field, and Logic App is selected in the search results.](../images/image80.png 'Azure Portal')

3.  Select the **Create** button on the Logic App overview blade.

4.  On the **Create Logic App** blade, specify the following configuration options:

    a. For Name, type a unique value for the App name similar to **TollBoothLogic** (ensure the green check mark appears).

    b. Specify the Resource Group **ServerlessArchitecture**.

    c. Select the same **location** as your Resource Group.

    d. Select **Off** underneath Log Analytics.

    ![In the Create logic app blade, fields are set to the previously defined settings.](../images/image81.png 'Create logic app blade')

5.  Click **Create**. Open the Logic App once it has been provisioned.

6.  In the Logic App Designer, scroll through the page until you locate the _Start with a common trigger_ section. Select the **Recurrence** trigger.

    ![The Recurrence tile is selected in the Logic App Designer.](../images/image82.png 'Logic App Designer')

7.  Enter **15** into the **Interval** box, and make sure Frequency is set to **Minute**. This can be set to an hour or some other interval, depending on business requirements.

8.  Select **+ New step**.

    ![Under Recurrence, the Interval field is set to 15, and the + New step button is selected.](../images/image83.png 'Logic App Designer Recurrence section')

9.  Enter **Functions** in the filter box, then select the **Azure Functions** connector.

    ![Under Choose an action, Functions is typed in the search box. Under Connectors, Azure Functions is selected.](../images/image85.png 'Logic App Designer Choose an action section')

10. Select your Function App whose name ends in **FunctionApp**, or contains the ExportLicensePlates function.

    ![Under Azure Functions, in the search results list, Azure Functions (TollBoothFunctionApp) is selected.](../images/image86.png 'Logic App Designer Azure Functions section')

11. Select the **ExportLicensePlates** function from the list.

    ![Under Azure Functions, under Actions (2), Azure Functions (ExportLicensePlates) is selected.](../images/image87.png 'Logic App Designer Azure Functions section')

12. This function does not require any parameters that need to be sent when it gets called. Select **+ New step**, then search for **condition**. Select the **Condition** Control option from the Actions search result.

    ![Under ExportLicensePlates, the field is blank. Under the + New step button, Add a condition is selected.](../images/logicapp-add-condition.png 'Logic App Designer ExportLicensePlates section')

13. For the **value** field, select the **Status code** parameter. Make sure the operator is set to **is equal to**, then enter **200** in the second value field.

    > **Note**: This evaluates the status code returned from the ExportLicensePlates function, which will return a 200 code when license plates are found and exported. Otherwise, it sends a 204 (NoContent) status code when no license plates were discovered that need to be exported. We will conditionally send an email if any response other than 200 is returned.

    ![The first Condition field displays Status code. The second, drop-down menu field displays is equal to, and the third field is set to 200.](../images/logicapp-condition.png 'Condition fields')

14. We will ignore the If true condition because we don't want to perform an action if the license plates are successfully exported. Select **Add an action** within the **If false** condition block.

    ![Under the Conditions field is an If true (green checkmark) section, and an if false (red x) section. In the If false section, Add an action is selected.](../images/logicapp-condition-false-add.png 'Logic App Designer Condition fields if true/false ')

15. Enter **Send an email** in the filter box, then select the **Send an email** action.

    ![From the Actions list, Office 365 Outlook (Send an email) is selected.](../images/logicapp-send-email.png 'Office 365 Outlook Actions list')

16. Click **Sign in** and sign into your Office 365 Outlook account.

    ![In the Office 365 Outlook - Send an email prompt, the Sign in button is selected.](../images/image93.png 'Office 365 Outlook Sign in prompt')

17. In the Send an email form, provide the following values:

    a. Enter your email address in the **To** box.

    b. Provide a **subject**, such as **Toll Booth license plate export failed**.

    c. Enter a message into the **body**, and select the **Status code** from the ExportLicensePlates function so that it is added to the email body.

    ![Under Send an email, fields are set to the previously defined settings. ](../images/image94.png 'Logic App Designer , Send an email fields')

18. Select **Save** in the tool bar to save your Logic App.

19. Select **Run** to execute the Logic App. You should start receiving email alerts because the license plate data is not being exported. This is because we need to finish making changes to the ExportLicensePlates function so that it can extract the license plate data from Azure Cosmos DB, generate the CSV file, and upload it to Blob storage.

    ![The Run button is selected on the Logic Apps Designer blade toolbar.](../images/image95.png 'Logic Apps Designer blade')

20. While in the Logic Apps Designer, you will see the run result of each step of your workflow. A green checkmark is placed next to each step that successfully executed, showing the execution time to complete. This can be used to see how each step is working, and you can select the executed step and see the raw output.

    ![In the Logic App Designer, green check marks display next to Recurrence, ExportLicensePlates, Condition, and Send an email.](../images/image96.png 'Logic App Designer ')

21. The Logic App will continue to run in the background, executing every 15 minutes (or whichever interval you set) until you disable it. To disable the app, go to the **Overview** blade for the Logic App and select the **Disable** button on the taskbar.

    ![The Disable button is selected on the TollBoothLogic blade top menu.](../images/image97.png 'TollBoothLogic blade')

