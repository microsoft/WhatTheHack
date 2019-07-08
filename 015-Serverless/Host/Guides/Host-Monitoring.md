# Challenge 6 - Monitoring

### Help references


|                                                               |                                                                                  |
| ------------------------------------------------------------- | :------------------------------------------------------------------------------: |
| **Description**                                               |                                    **Links**                                     |
| Monitor Azure Functions using Application Insights            |     <https://docs.microsoft.com/azure/azure-functions/functions-monitoring>      |
| Live Metrics Stream: Monitor & Diagnose with 1-second latency | <https://docs.microsoft.com/azure/application-insights/app-insights-live-stream> |


### Task 1: Provision an Application Insights instance

1.  Navigate to the Azure Management portal, <http://portal.azure.com>.

2.  Select **+ Create a resource**, then type **application insights** into the search box on top. Select **Application Insights** from the results.

    ![In the Azure Portal menu pane, New is selected. In the New blade, application inisght is typed in the search box, and Application insights is selected from the search results.](../images/image60.png 'Azure Portal')

3.  Select the **Create** button on the **Application Insights overview** blade.

4.  On the **Application Insights** blade, specify the following configuration options:

    a. **Name**: Unique value for the App name similar to **TollboothMonitor** (ensure the green check mark appears).

    b. For Application Type, select **ASP.NET web application**.

    c. Specify the **Resource Group** **ServerlessArchitecture**.

    d. Select the same **location** as your Resource Group.

    ![Fields in the Application Insights blade are set to the previously defined settings.](../images/image61.png 'Application Insights blade')

5.  Select **Create**.

### Task 2: Enable Application Insights integration in your Function Apps

Both of the Function Apps need to be updated with the Application Insights instrumentation key so they can start sending telemetry to your new instance.

1.  After the Application Insights account has completed provisioning, open the instance by opening the **ServerlessArchitecture** resource group, and then selecting the your recently created application insights instance.

2.  Copy the **instrumentation key** from the Essentials section of the **Overview** blade.

> **Note**: You may need to expand the **Essentials** section.

![In the pane of the TollBoothMonitor blade, Overview is selected. In the pane, the copy button next to the Instrumentation key is selected.](../images/image62.png 'TollBoothMonitor blade')

3.  Open the Azure Function App you created whose name ends with **FunctionApp**, or the name you specified for the Function App containing the ProcessImage function.

4.  Select on **Application settings** on the **Overview** pane.

    ![In the pane of the TollBoothFunctionApp blade, under Configured features, Application settings is selected.](../images/image34.png 'TollBoothFunctionApp blade')

5.  Scroll down to the **Application settings** section. Use the **+ Add new setting** link and name the new setting **APPINSIGHTS_INSTRUMENTATIONKEY**. Paste the copied instrumentation key into its value field.

    ![In the TollBoothFunctionApp blade, the + Add new setting link is selected. In the list of application settings, APPINSIGHTS_INSTRUMENTATIONKEY is selected.](../images/image63.png 'TollBoothFunctionApp blade')

6.  Select **Save**.

    ![Screenshot of the Save icon.](../images/image36.png 'Save icon')

7.  Follow the steps above to add the APPINSIGHTS_INSTRUMENTATIONKEY setting to the function app that ends in **Events**.

### Task 3: Use the Live Metrics Stream to monitor functions in real time

Now that Application Insights has been integrated into your Function Apps, you can use the Live Metrics Stream to see the functions' telemetry in real time.

1.  Open the Azure Function App you created whose name ends with **FunctionApp**, or the name you specified for the Function App containing the ProcessImage function.

2.  Select **Application Insights** on the Overview pane.

    > **Note**: It may take a few minutes for this link to display.

    ![In the TollBoothFunctionApp blade, under Configured features, the Application Insights link is selected.](../images/image64.png 'TollBoothFunctionApp blade')

3.  In Application Insights, select **Live Metrics Stream** underneath Investigate in the menu.

    ![In the TollBoothMonitor blade, in the pane under Investigate, Live Metrics Stream is selected. ](../images/image65.png 'TollBoothMonitor blade')

4.  Leave the Live Metrics Stream open and go back to the starter app solution in Visual Studio.

5.  Navigate to the **UploadImages** project using the Solution Explorer of Visual Studio.

    ![In Solution Explorer, UploadImages is expanded, and App.config is selected.](../images/image66.png 'Solution Explorer')

6.  Open **App.config**.

7.  In App.config, update the **blobStorageConnection** appSetting value to the connection string for your Blob storage account.

    ![On the App.config tab, a connection string is circled. To the side of the string is a green bar, and a hammer icon.](../images/image67.png 'App.config tab')

8.  Save your changes to the file.

9.  Right-click the **UploadImages** project in the Solution Explorer, then select **Debug** then **Start new instance**.

    ![In Solution Explorer, UploadImages is selected. From the Debug menu, Start new instance is selected.](../images/image68.png 'Solution Explorer')

10. When the console window appears, enter **1** and press **ENTER**. This uploads a handful of car photos to the images container of your Blob storage account.

    ![A Command prompt window displays, showing images being uploaded.](../images/image69.png 'Command prompt window')

11. Switch back to your browser window with the Live Metrics Stream still open within Application Insights. You should start seeing new telemetry arrive, showing the number of servers online, the incoming request rate, CPU process amount, etc. You can select some of the sample telemetry in the list to the side to view output data.

    ![The Live Metrics Stream window displays information for the two online servers. Displaying line and point graphs include incoming requests, outgoing requests, and overvall health. To the side is a list of Sample Telemetry information. ](../images/image70.png 'Live Metrics Stream window')

12. Leave the Live Metrics Stream window open once again, and close the console window for the image upload. Debug the UploadImages project again, then enter **2** and press **ENTER**. This will upload 1,000 new photos.

    ![the Command prompt window displays with image uploading information.](../images/image71.png 'Command prompt window')

13. Switch back to the Live Metrics Stream window and observe the activity as the photos are uploaded. It is possible that the process will run so efficiently that no more than two servers will be allocated at a time. You should also notice things such as a steady cadence for the Request Rate monitor, the Request Duration hovering below \~500ms second, and the Process CPU percentage roughly matching the Request Rate.

    ![In the Live Metrics Stream window, two servers are online. Under Incoming Requests. the Request Rate heartbeat line graph is selected, as is the Request Duration dot graph. Under Overall Health, the Process CPU heartbeat line graph is also selected, and a bi-directional dotted line points out the similarities between this graph and the Request Rate graph under Incoming Requests.](../images/image72.png 'Live Metrics Stream window ')

14. After this has run for a while, close the image uploader console window once again, but leave the Live Metrics Stream window open.



[Next optional challenge A (Scale the Cognitive Service) >](./Host-ScaleCognitive.md)

Or

[Next optional challenge B (View Data in Cosmos DB) >](./Host-Cosmos.md)

Or

[Next challenge (Data Export Workflow) >](./Host-Workflow.md)
