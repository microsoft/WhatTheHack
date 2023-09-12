# Challenge 04 - Run the Game Continuously - Coach's Guide

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

### Create the Logic App

1.  Run the following Azure CLI command to create the Logic App (note that the `workflow.json` file path is inside the `Student/Resources` directory)

    ```shell
    az logic workflow create --name <logicapp-name> --resource-group <resource-group-name> --location <location> --definition workflow.json
    ```

    > Notes: 
    > - You can also use the Azure Portal to create the Logic App.
    > - The CLI may need to install the `logic` extension.  Choose `Y` to continue.
    > - Ensure your `resource group` is in the correct region.  South Central US is a valid resource group at the time of this WTH creation.  If your resource group is not in the correct region, create a new `resource goup` in the correct region and re-run the command.


1.  Open the Logic App in the Azure Portal and click on the `Recurrence` trigger.

1.  Set the recurrence to run every 5 minutes.

1.  Click on the `HTTP` action and set the `Method` to `POST`.

1.  Set the `URI` to the API URL of your Rock Paper Scissors Boom Server app with the API path appended to the end.

    ```shell
    https://<app-service-name>.azurewebsites.net/api/rungame
    ```

1.  Click `Save`.

### Test the Logic App

1.  Click `Run Trigger` button to test

1.  Navigate to the web app, click on the `Run the Game` button and start clicking on the refresh button to see the game being played.
