# Challenge 4: Deploy the bot and integrate with teams
[< Previous Challenge](./Challenge3-API.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge5-FrontEnd.md)
## Introduction
Now that we've finished developing our bot locally we can deploy the bot. Deployment is key so that we can get the bot in the hands of our Testers to ensure our dialogs are robust enough. Fortunately, deployment is semi-built into the Bot Composer interface.
	
## Description
1. First you must deploy your bot to Azure Web Apps:
	 - In the Composer add a new publish profile and choose to publish bot to Azure Web Apps.
	 - Ensure that no errors occurred and test your bot through the azure portal.
	 - Test you endpoint using the Bot Framework Emulator. You will need to install [Ngrok](https://ngrok.com/) 
2. Then we can integrate with Teams. (if you do not have Teams licenses in your organization, this challenge is optional for you.)
	 - In your Azure Bot Channel Registration, create a Teams Channel
	 - Add the bot as an app in Microsoft Teams
	 - You can use the sample image icons as you Teams App icon - those png files are in the [Resource folder](./Resources/).

## Success Criteria
1. The bot has been deployed out to a Azure Web Apps and you're able to test against it using the Bot Framework Emulator.
2. Successfully message the bot in Microsoft Teams (if you do not have Teams licenses in your organization, this challenge is optional for you.)


## Resources
* [How to publish a Bot](https://docs.microsoft.com/en-us/composer/how-to-publish-bot)
* [Connect a bot to Microsoft Teams](https://docs.microsoft.com/en-us/azure/bot-service/channel-connect-teams?view=azure-bot-service-4.0) 


[Next Challenge - Embed your bot >](./Challenge5-FrontEnd.md)
