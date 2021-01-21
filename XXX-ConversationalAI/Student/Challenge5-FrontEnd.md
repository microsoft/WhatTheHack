# Challenge 5: Embed your Bot to the sample Front End Web Application and enable Direct Line Speech
[< Previous Challenge](./Challenge4-Deployment.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge6-ACS.md)

## Introduction
Now that we've finished deployed our Bot into Azure. You can then enriching your Bot user interface through a sample web application. Also, in this challenge, let's explore how you can enable the speech capabilities of the Bot. 
	
## Description
1. Embed the Bot into a Web Page. 
	* By going to Azure Portal, go to the Bot Channel Registration resource
	* Navigate to the Web Chat Channel - click Edit, you will find the Secret key as well as the Embed Iframe code
	* Create a HTML file in your machine, place the HTML boy section the the iframe code and add the secret key to the iframe code.
	* Now you can run the web page locally 

2. Voice enable your bot through Direct Line Speech channel

3. Explore different capabilities you can do with Direct Line Speech 

4. Demostrate to the coach your voice enabled Bot through Microsoft Speech SDK. 

5. (optional) Can you make a simple page with speech-to-text and text-to-speech feature from Direct Line Speech channel? 

## Success Criteria
1. Created a Web Page with your Bot embeded on it. 
2. Demostrated the speech capability of your bot through Microsoft Speech SDK. 


## Resources
- [Connect a bot to Direct Line Speech](https://docs.microsoft.com/en-us/azure/bot-service/bot-service-channel-connect-directlinespeech?view=azure-bot-service-4.0#:~:text=Add%20the%20Direct%20Line%20Speech%20channel%20In%20your,the%20bot.%20In%20the%20left%20panel%2C%20select%20Channels.)
- [Sample - Integrating with Direct Line Speech channel](https://github.com/microsoft/BotFramework-WebChat/tree/master/samples/03.speech/a.direct-line-speech)

[Next Challenge - Extent to Azure Communication Service >](./Challenge6-ACS.md)
