# Challenge 5: Direct Line Speech Channel and Front End
[< Previous Solution](./Solution-4.md) - **[Home](./Readme.md)** - [Next Solution>](./Solution-6.md)
## Notes & Guidance
1. Embed the Bot into a HTML Web Page. 
    * By going to Azure Portal, go to the Bot Channel Registration resource
    * Navigate to the Web Chat Channel - click Edit, you will find the Secret key as well as the Embed Iframe code
    * Create an HTML page locally; add Secret Key to the iframe code; Place the provided iframe code to the HTML body section.
    * Now you can run the web page locally 
2. You can follow the exact [step by step guidance](https://docs.microsoft.com/en-us/azure/bot-service/bot-service-channel-connect-directlinespeech?view=azure-bot-service-4.0) to create a Direct Line Speech Channel to your bot. 
3. Then, scroll down the guidance, you will find the Example session where you can find the ['Voice-enable your bot using the Speech SDK'](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/tutorial-voice-enable-your-bot-speech-sdk) link.
4. Following that link, you can jump directly to the ['Run the Windows Voice Assistant Client'](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/tutorial-voice-enable-your-bot-speech-sdk#run-the-windows-voice-assistant-client) section.
5. If the student chooses the optional challenge and creates Voice-Enabled Web Chat. The major challenge here is how they handle the authentication method. The best practice is to use the authorization token. And, the easiest way to demonstrate that is to use Postman to generate the token. In production, people will create a function for token generation. 

