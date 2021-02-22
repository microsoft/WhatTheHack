# Challenge 4: Deploy the bot and integrate with teams
[< Previous Solution](./Solution-3.md) - **[Home](./Readme.md)** - [Next Solution>](./Solution-5.md)
## Notes & Guidance
1. First, you must deploy your bot to Azure Web Apps:
     - Follow the official Doc Guidance step by step. https://docs.microsoft.com/en-us/composer/how-to-publish-bot
     - Publish may take a while. 
     - If you need to republish, pay attention to the Azure Token, and it may expire after a while. Use the command-line tool to get a new token 
        * Run `az account get-access-token` 
     - Ensure that no errors occurred and test your bot through the Azure portal.
     - Test your endpoint using the Bot Framework Emulator. You will need to install [Ngrok](https://ngrok.com/) 
2. Then we can integrate with Teams.
     - Follow this step by step guild to create a Teams Channel in  your Azure Bot Channel Registration resource: https://docs.microsoft.com/en-us/azure/bot-service/channel-connect-teams?view=azure-bot-service-4.0
     - Add the bot as an app in Microsoft Teams https://docs.microsoft.com/en-us/microsoftteams/platform/concepts/build-and-test/apps-package
        
        * Open 'App Studio' in Teams Apps store
        * Open Manifest editor tab
        * Create a New App
        * In the App details page, fill in all the customized information you like. The challenging part is to get app icons to be exact size so you can online to find one.
        * In the Capabilities, choose 'Bots' and click on Setup -> Choose the 'Existing Bot' Tab
        * and click on the Connect to a different bot id. You can find the Bot ID in Azure Portal: Bot Channels Registration Service, under Bot management, Settings, and find the Microsoft App ID. 

        
