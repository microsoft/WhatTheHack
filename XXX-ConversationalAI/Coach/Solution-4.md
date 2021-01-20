# Challenge 4: Deploy the bot and integrate with teams
[< Previous Solution](./Solution-3.md) - **[Home](../readme.md)** - [Next Solution>](./Solution-5.md)
## Introduction
Now that we've finished developing our bot locally we can deploy the bot. Deployment is key so that we can get the bot in the hands of our Testers to ensure our dialogs are robust enough. Fortunately, deployment is semi-built into the Bot Composer interface.
	
## Description
1. First you must deploy your bot to Azure Web Apps:
	 - Follow the official Doc Guidance step by step. https://docs.microsoft.com/en-us/composer/how-to-publish-bot
	 - Ensure that no errors occurred and test your bot through the azure portal.
	 - Test you endpoint using the Bot Framework Emulator. You will need to install [Ngrok](https://ngrok.com/) 
2. Then we can integrate with Teams.
	 - Follow this step by step guild to create a Teams Channel in  your Azure Bot Channel Registration resource: https://docs.microsoft.com/en-us/azure/bot-service/channel-connect-teams?view=azure-bot-service-4.0
     - Add the bot as an app in Microsoft Teams https://docs.microsoft.com/en-us/microsoftteams/platform/concepts/build-and-test/apps-package


## Success Criteria
1. The bot has been deployed out to a Azure Web Apps and you're able to test against it using the Bot Framework Emulator.
2. Successfully message the bot in Microsoft Teams


## Resources
	- [Publish a Bot](https://docs.microsoft.com/en-us/composer/how-to-publish-bot)
	- [Connect a bot to Microsoft Teams](https://docs.microsoft.com/en-us/azure/bot-service/channel-connect-teams?view=azure-bot-service-4.0) 


[Next Solution - Embed your bot >](./solution-5.md)