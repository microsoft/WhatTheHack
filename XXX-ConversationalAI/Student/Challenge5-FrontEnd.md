# Challenge 5: Embed your Bot to the sample Front End Web Application and enable Direct Line Speech
[< Previous Challenge](./Challenge4-Deployment.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge6-ACS.md)

## Introduction
Now that we've finished deployed our Bot into Azure. You can then enriching your Bot user interface through a sample web application. Also, in this challenge, let's explore how you can enable the Bot's speech capabilities. 
    
## Description
1. Embed the Bot into a Web Page. 
    * By going to Azure Portal, go to the Bot Channel Registration resource
    * Navigate to the Web Chat Channel - click Edit, you will find the Secret key as well as the Embed Iframe code
    * Create an HTML page locally; add Secret Key to the iframe code; Place the provided iframe code to the HTML body section.
    * Now you can run the web page locally 

2. Make your Bot into a Voice-Enabled Bot through the Direct Line Speech channel

3. Explore different capabilities you can do with the Direct Line Speech channel

4. Demonstrate to the coach that your voice-enabled Bot through Windows Voice Assistant Client. 

5. (optional) Can you make a simple page with a speech-to-text and text-to-speech feature from the Direct Line Speech channel? 

## Success Criteria
1. Created a Web Page with your Bot embedded on it. 
2. Demonstrated the speech capability of your Bot through Microsoft Speech SDK. 


## Resources
- [Connect a bot to Direct Line Speech](https://docs.microsoft.com/en-us/azure/bot-service/bot-service-channel-connect-directlinespeech?view=azure-bot-service-4.0#:~:text=Add%20the%20Direct%20Line%20Speech%20channel%20In%20your,the%20bot.%20In%20the%20left%20panel%2C%20select%20Channels.)
- [Sample - Web Chat Integrating with Direct Line Speech channel](https://github.com/microsoft/BotFramework-WebChat/tree/master/samples/03.speech/a.direct-line-speech)

## What a sample result looks like
![Sample](./Images/Ch5-1.JPG)
![Sample](./Images/Ch5-2.JPG)

[Next Challenge - Extent to Azure Communication Service >](./Challenge6-ACS.md)
