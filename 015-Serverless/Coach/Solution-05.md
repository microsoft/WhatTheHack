# Challenge 05 - Deployment - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

*As of May 2020, there is a new Portal view of the functions*
1) Those that are not familiar with Azure functions will not know about how the Applications Settings work with the Function Code
2) Key Vault reference in the Function App will require a reference __@Microsoft.KeyVault__ in the app setting value
3) __ERRORS on KEY VAULT__
You cannot see if there is an error in the new portal.  Navigate to the old portal and if you see this error, the reference to the key vault is bad: ![Key Vault Error](./images/keyvault-error.PNG)

Participants may need to allow an identity access [Identity Access](https://docs.microsoft.com/en-us/azure/app-service/overview-managed-identity?context=azure%2Factive-directory%2Fmanaged-identities-azure-resources%2Fcontext%2Fmsi-context&tabs=dotnet)

Then add permissions in Key Vault to the Function
Success looks like this ![Key Vault Success](./images/keyvault-success.PNG)


## Step by Step Instructions

### Help references

- [Deploy Functions to Azure](https://www.thebestcsharpprogrammerintheworld.com/2018/08/21/deploy-an-azure-function-created-from-visual-studio-2/)


### **Errors in new portal**
**The new Function App portal will display errors and not allow students to edit the Event Grid subscriptions.  These will need to be done in the old Function App portal**

1.  Navigate to the **TollBooth** project using the Solution Explorer of Visual Studio.

2.  Right-click the **TollBooth** project and select **Publish** from the context menu.

3.  In the Pick a Publish Target window that appears, make sure **Azure Function App** is selected, choose the **Select Existing** radio button, then select **Publish**.

> **Note**: If you do not see the ability to publish to an Azure Function, you may need to update your Visual Studio instance.

1.  In the App Service form, select your **Subscription**, select **Resource Group** under **View**, then expand your **ServerlessArchitecture** resource group and select the Function App whose name ends with **FunctionApp**.

2.  Whatever you named the Function App when you provisioned it is fine. Just make sure it is the same one to which you applied the Application Settings in Task 1 of this exercise.

3.  After you select the Function App, select **OK**.

    > **Note**: If prompted to update the functions version on Azure, click **Yes**.

4.  Watch the Output window in Visual Studio as the Function App publishes. When it is finished, you should see a message that says, "Publish Succeeded."

5.  Using a new tab or instance of your browser navigate to the Azure Management portal, <http://portal.azure.com>.

6.  Open the **ServerlessArchitecture** resource group, then select the Azure Function App to which you just published.

7.  Expand the functions underneath your Function App in the menu. You should see both functions you just published from the Visual Studio solution listed.

8.  Now we need to add an Event Grid subscription to the ProcessImage function so the function is triggered when new images are added to blob storage. Select the **ProcessImage** function, then select **Add Event Grid subscription**.

9.  On the **Create Event Subscription** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name similar to **processimagesub** (ensure the green check mark appears).

    b. **Event Schema**: Select Event Grid Schema.

    c. For **Topic Type**, select **Storage Accounts**.

    d. Select your **subscription** and **ServerlessArchitecture** resource group.

    e. For resource, select your recently created Event Grid.

    f. _Uncheck_ **Subscribe to all event types**, then select **Blob Created** from the event types dropdown list.

    g. Leave Web Hook as the Endpoint Type.

10. Leave the remaining fields at their default values and select **Create**.
