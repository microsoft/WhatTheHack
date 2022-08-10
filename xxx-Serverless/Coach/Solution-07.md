# Challenge 07 - Monitoring - Coach's Guide 

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07A.md)

## Notes & Guidance

The App insights can be created in new or old functions portal.  In new, Instrumentation key is not needed.  In old, the key will need to be added to the app settings.

For edits to the App.config, the following will need to be added:
```javascript
  <appSettings>
    <add key ="blobStorageConnection" value="THEIR_BLOB_CONNECTION_STRING"></add>
  </appSettings>
```

If students still get a storage account error, then they need to add the connection string to the Debug tab in the Function's properties Command Line arguements


## Step by Step Instructions

### Help references

- [Monitor Azure Functions using Application Insights](https://docs.microsoft.com/azure/azure-functions/functions-monitoring)
- [Live Metrics Stream: Monitor & Diagnose with 1-second latency](https://docs.microsoft.com/azure/application-insights/app-insights-live-stream)

### Task 1: Provision an Application Insights instance


### **Application Insights in the new Function App portal**
**The new Function App portal will allow students to create the link to application insights without adding the instrumentation key to the application settings.  The below instructions are for those that use the old Function App portal**

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then type **application insights** into the search box on top. Select **Application Insights** from the results.

3.  Select the **Create** button on the **Application Insights overview** blade.

4.  On the **Application Insights** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name similar to **TollboothMonitor** (ensure the green check mark appears).

    b. For Application Type, select **ASP.NET web application**.

    c. Specify the **Resource Group** **ServerlessArchitecture**.

    d. Select the same **location** as your Resource Group.

5.  Select **Create**.

### Task 2: Enable Application Insights integration in your Function Apps

Both of the Function Apps need to be updated with the Application Insights instrumentation key so they can start sending telemetry to your new instance.

1.  After the Application Insights account has completed provisioning, open the instance by opening the **ServerlessArchitecture** resource group, and then selecting the your recently created application insights instance.

2.  Copy the **instrumentation key** from the Essentials section of the **Overview** blade.

> **Note**: You may need to expand the **Essentials** section.

3.  Open the Azure Function App you created whose name ends with **FunctionApp**, or the name you specified for the Function App containing the ProcessImage function.

4.  Select on **Application settings** on the **Overview** pane.

5.  Scroll down to the **Application settings** section. Use the **+ Add new setting** link and name the new setting **APPINSIGHTS_INSTRUMENTATIONKEY**. Paste the copied instrumentation key into its value field.

6.  Select **Save**.

7.  Follow the steps above to add the APPINSIGHTS_INSTRUMENTATIONKEY setting to the function app that ends in **Events**.

### Task 3: Use the Live Metrics Stream to monitor functions in real time

Now that Application Insights has been integrated into your Function Apps, you can use the Live Metrics Stream to see the functions' telemetry in real time.

1.  Open the Azure Function App you created whose name ends with **FunctionApp**, or the name you specified for the Function App containing the ProcessImage function.

2.  Select **Application Insights** on the Overview pane.

    > **Note**: It may take a few minutes for this link to display.

3.  In Application Insights, select **Live Metrics Stream** underneath Investigate in the menu.

4.  Leave the Live Metrics Stream open and go back to the starter app solution in Visual Studio.

5.  Navigate to the **UploadImages** project using the Solution Explorer of Visual Studio.

6.  Open **App.config**.

7.  In App.config, update the **blobStorageConnection** appSetting value to the connection string for your Blob storage account.

8.  Save your changes to the file.

9.  Right-click the **UploadImages** project in the Solution Explorer, then select **Debug** then **Start new instance**.

10. When the console window appears, enter **1** and press **ENTER**. This uploads a handful of car photos to the images container of your Blob storage account.

11. Switch back to your browser window with the Live Metrics Stream still open within Application Insights. You should start seeing new telemetry arrive, showing the number of servers online, the incoming request rate, CPU process amount, etc. You can select some of the sample telemetry in the list to the side to view output data.

12. Leave the Live Metrics Stream window open once again, and close the console window for the image upload. Debug the UploadImages project again, then enter **2** and press **ENTER**. This will upload 1,000 new photos.

13. Switch back to the Live Metrics Stream window and observe the activity as the photos are uploaded. It is possible that the process will run so efficiently that no more than two servers will be allocated at a time. You should also notice things such as a steady cadence for the Request Rate monitor, the Request Duration hovering below \~500ms second, and the Process CPU percentage roughly matching the Request Rate.

14. After this has run for a while, close the image uploader console window once again, but leave the Live Metrics Stream window open.
