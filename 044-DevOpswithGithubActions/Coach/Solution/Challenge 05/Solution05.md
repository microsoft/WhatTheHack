# Securing yours API with API Management


### Task 1: Import API App

In this task, you import your API App into APIM, using the OpenAPI specification, which leverages the Swagger definition associated with your API app.

1. In the Azure portal, navigate to your **API Management Service** by selecting it from the list of resources under your hands-on-lab-SUFFIX resource group.

   ![The API Management service is highlighted in the resources list.](media/azure-resources-api-management.png "API Management service")

2. On the API Management service select the **APIs** blade, and then select **+ Add API** and select **OpenAPI**.

   ![API Management Service with APIs blade selected. A button to add a new OpenAPI is highlighted](media/apim-add-api.png "API Management Service Add OpenAPI")

3. A dialog to Create from OpenAPI specification is displayed. Select **Full** to expand the options that need to be entered.

   ![The Create from OpenAPI specification dialog is displayed and Full is highlighted](media/e8-t1-create-api-dialog.png "Create from OpenAPI specification")

4. Retrieve the value for the OpenAPI specification field from the `swagger` page of your API APP. (This is the URL of your API app, which you can retrieve from its overview blade in the Azure portal) plus "/swagger". (e.g., <https://contoso-api-jt7yc3zphxfda.azurewebsites.net/swagger>).

5. On the Swagger page for your API App, right-click on the `swagger/v1/swagger.json` file link just below the PolicyConnect API title, and select **Copy link address**.

   ![A context menu is displayed next to the swagger/v1/swagger.json link, and Copy link address is highlighted.](media/swagger-copy-json-link-address.png "Swagger")

6. Return to the API Management Create from OpenAPI specification dialog, and enter the following:

   - **OpenAPI specification**: Paste the copied link address from your Swagger page.
   - **Display name**: This is automatically populated from the Swagger definition.
   - **Name**: This is automatically populated from the Swagger definition.
   - **URL scheme**: Choose **HTTPS**.
   - **Products**: Select the **Unlimited** tag by clicking the field and selecting it from the dropdown list.

   ![Create from OpenAPI specification dialog is filled and the create button is highlighted.](media/open-api-dialog-complete.png "Create OpenAPI specification")

7. After creating the API, select the **PolicyConnect API** from the list of APIs on the left, and on the Design tab, with All operations selected, select the **Policies** icon in the Inbound process tile.

   ![On the All operations section, the Inbound processing policies icon is highlighted.](media/apim-inbound-processing.png "API Management")

8. On the Policies screen, insert the code below between the `<inbound></inbound>` tags, and below the `<base />` tag. You need to **replace** `<your-web-app-url>` between the `<origin></origin>` tags with the URL for your Web App.

   ```xml
   <cors allow-credentials="true">
       <allowed-origins>
           <origin><your-web-app-url></origin>
       </allowed-origins>
       <allowed-methods>
           <method>*</method>
       </allowed-methods>
       <allowed-headers>
           <header>*</header>
       </allowed-headers>
       <expose-headers>
           <header>*</header>
       </expose-headers>
   </cors>
   ```

   Your updated policies value should look similar to the following:

   ![The XML code above has been inserted into the Policies XML document.](media/apim-policies.png "API Management")

   > **Note**: The policy added above is for handling cross-origin resource sharing (CORS). If you are testing the web app locally, you need to add another `<origin></origin>` tag within `<allowed-origins></allowed-origins>` that contains `https://localhost:<port-number>`, where `<port-number>` is the port assigned by your debugger (as is shown in the screenshot above).

9. Select **Save**.

10. Next, select the **Settings** tab. On the Settings tab, enter the URL of your API App, starting with `https://`. **Note**: You can copy this value from the text editor you have been using to store values throughout this lab.

    ![The settings tab for the PolicyConnect API is displayed, with the API App url entered into the Web Service URL field.](media/apim-policyconnect-api-settings.png "API Settings")

11. Select **Save** on the Settings tab.

### Task 2: Import Function App

In this task, you import your Function App into APIM.

1. Select **+ Add API** again, and this time select **Function App** as the source of the API.

   ![Add API is highlighted in the left-hand menu, and the Function App tile is highlighted.](media/api-management-add-function-app.png "API Management")

2. On the Create from Function App dialog, select the **Browse** button next to the Function App field.

3. In the Import Azure Functions blade, select **Function App Configure required settings** and then select your Function App from the list, and choose **Select**.

   ![The Select Function App dialog is displayed, and hands-on-lab-SUFFIX is entered into the filter box.](media/select-function-app.png "Select Function App")

   > **Note**: You can filter using your resource group name, if needed.

4. Back on the Import Azure Functions blade, ensure the PolicyDocs function is checked, and choose **Select**.

   ![The Import Azure Functions blade is displayed, with the configuration specified above set.](media/import-azure-functions.png "Import Azure Functions")

5. Back on the Create from Function App dialog in APIM, all of the properties for the API are set from your Azure Function. Set the Products to Unlimited, as you did previously. Note, you may need to select **Full** at the top to see the Products box.

   ![On the Create from Function App dialog, the values specified above are entered into the form.](media/apim-create-from-function-app.png "API Management")

6. Select **Create**.

7. After the Function App API is created, select it from the left-hand menu, select the **Settings** tab, and under **Products** select **Unlimited**.

   ![On the Settings tab for the newly created Function App managed API, Unlimited is highlighted in the Products field.](media/apim-create-from-function-app-settings.png "API settings for Function App")

8. Select **Save**.

### Task 3: Open Developer Portal and retrieve you API key

In this task, you quickly look at the APIs in the Developer Portal, and retrieve your key. The Developer Portal allows you to check the list of APIs and endpoints as well as find useful information about them.

1. Open the APIM Developer Portal by selecting **Developer portal (legacy)** from the Overview blade of your API Management service in the Azure portal.

   ![On the APIM Service Overview blade the link for the developer portal is highlighted.](media/apim-developer-portal.png "Developer Portal")

2. In the Azure API Management portal, select **APIs** from the top menu, and then select the API associated with your Function App.

   ![In the Developer portal, the APIs menu item is selected and highlighted, and the Function App API is highlighted.](media/dev-portal-apis-function-app.png "Developer portal")

3. The API page allows you to view and test your API endpoints directly in the Developer portal.

   ![The Profile link is highlighted on the API page for the Function App API.](media/apim-endpoint-details.png "API Management")

4. Copy the highlighted request URL. This is the new value you use for the `PolicyDocumentsPath` setting in the next task.

   > **Note**: We don't need to do this for the PolicyConnect API because the path is defined by the Swagger definition. The only thing that needs to change for that is the base URL, which points to APIM and not your API App.

5. Next, select the **Administrator** drop down located near the top right of the API page, and then select **Profile** from the fly-out menu. The **Profile** page allows you to retrieve your `Ocp-Apim-Subscription-Key` value, which you need to retrieve so the PolicyConnect web application can access the APIs through APIM.

6. On the Profile page, select **Show** next to the Primary Key for the **Unlimited** Product, copy the key value and paste it into a text editor for use below.

   ![The Primary Key field is highlighted under the Unlimited subscription.](media/apim-dev-portal-subscription-keys.png "API Management Developer Portal")

### Task 4: Update Web App to use API Management Endpoints

In this task, you use the Azure Cloud Shell and Azure CLI to update the `ApiUrl` and `PolicyDocumentsPath` settings for the PolicyConnect Web App. You also add a new setting for the APIM access key.

1. In the [Azure portal](https://portal.azure.com), select the Azure Cloud Shell icon from the menu at the top right of the screen.

   ![The Azure Cloud Shell icon is highlighted in the Azure portal's top menu.](media/cloud-shell-icon.png "Azure Cloud Shell")

2. In the Cloud Shell window that opens at the bottom of your browser window, select **PowerShell**.

   ![In the Welcome to Azure Cloud Shell window, PowerShell is highlighted.](media/cloud-shell-select-powershell.png "Azure Cloud Shell")

3. After a moment, you receive a message that you have successfully requested a Cloud Shell, and be presented with a PS Azure prompt.

   ![In the Azure Cloud Shell dialog, a message is displayed that requesting a Cloud Shell succeeded, and the PS Azure prompt is displayed.](media/cloud-shell-ps-azure-prompt.png "Azure Cloud Shell")

4. At the Cloud Shell prompt, run the following command to retrieve your Web App name, making sure to replace `<your-resource-group-name>` with your resource group name:

   ```powershell
   $resourceGroup = "<your-resource-group-name>"
   az webapp list -g $resourceGroup --output table
   ```

5. In the output, copy the name of Web App (the resource name starts with contoso-**web**) into a text editor for use below.

   ![The Web App Name value is highlighted in the output of the command above.](media/azure-cloud-shell-az-webapp-list-web-app-name.png "Azure Cloud Shell")

6. Next replace the tokenized values in the following command as specified below, and then run it from the Azure Cloud Shell command prompt.

   - `<your-web-app-name>`: Replace with your Web App name, which you copied in above.
   - `<your-apim-gateway-url>`: Replace with the Gateway URL of your API Management instance, which you can find on the Overview blade of the API Management Service in the Azure portal.
   - `<your-apim-subscription-key>`: Replace with the APIM `Ocp-Apim-Subscription-Key` value that you copied into a text editor above.
   - `<your-apim-function-app-path>`: Replace with path you copied for your Function App within API Management, that is to be used for the `PolicyDocumentsPath` setting.

   ```powershell
   $webAppName = "<your-web-app-name>"
   $apimUrl = "<your-apim-gateway-url>"
   $apimKey = "<your-apim-subscription-key>"
   $policyDocsPath = "<your-apim-function-app-path>"
   az webapp config appsettings set -n $webAppName -g $resourceGroup --settings "PolicyDocumentsPath=$policyDocsPath" "ApiUrl=$apimUrl" "ApimSubscriptionKey=$apimKey"
   ```

7. In the output, note the newly added and updated settings in your Web App's application settings. The settings were updated by the script above and triggered a restart of your web app.

8. In a web browser, navigate to the Web app URL, and verify you still see data when you select one of the tabs.
