## Day 1 Instructor Notes

### How to conduct the session
* Give the students about 3 minutes to read the case and assignment
* Split the class into groups of about five. There should be an even number of groups (this will probably take about 2 minutes)
* Give the class 25 minutes to discuss within their groups
* Give the class 10 minutes to talk about their results with another group
* Take whatever time is left to show them some of the ideas below, and asking if anyone had other ideas
> Ideally, there would be one proctor per every two groups, to facilitate questions and provide insights if needed

### Potential answers to the questions

**What might your main intents in LUIS be?**
* Greeting
* Help menu
* Main menu / Start over
* Speak with an operator
* Search products
* Order products
* Check out
* Goodbye


**Are there any additional Cognitive Services that you think the bot would benefit from?**  
* Custom Speech Service - over come recognition barriers like speaking style, background, noise, and vocabulary
* Speaker Recognition API - you could authenticate/identify return customers
* Translator Speech API - give the user the option to speak in different languages
* Custom Decision Service - could use this to rank recommended items

> Note the [Recommendations API has been discontinued](https://docs.microsoft.com/en-us/azure/cognitive-services/Recommendations/overview), but there is still a [Recommendations Solution template](http://aka.ms/recopcs).

In addition, the CIO has asked you for examples of how Custom Vision could be
used to help to bring value to the business.

**Find one example of how the Custom Vision API can help?**

   **Potential Answer. (Other answers are also valid)**

   * Custom Vision API is about the classification of pictures based on the tags
   that have been trained within the model. Contoso would have to consider if
   there is a business process that is dependent on classification

   * One example could include bicycle part replacement. Contoso could train a
   Custom Vision model to identify certain bicycle parts and tag the images
   such as the front and rear wheel, saddles and handlebars.

   * The user could return a list of replacement parts by simply taking a
   picture of the part of their own bike, uploading the picture through a bot
   application, which then passes the image to the model, that will then
   classify the picture. Additional code within the application will take the
   tag as an input parameter to return a list of specific parts that could be
   purchased as a replacement.

   * Check out the “Technology in Action” section on how the insurance industry
   are thinking about a similar approach to insurance claims processing
   http://www.telegraph.co.uk/business/risk-insights/is-insurance-industry-ready-for-ai/

### Additional Information
Here's a [Learning Path](https://github.com/amthomas46/LearningPaths/blob/master/Developer/Learning%20Path%20-%20Interactive%20Voice%20Response%20Bot.md) I created if you want to know a little more about what goes into creating an Interactive Voice Response Bot.

This case was modified from this [Cortana Intelligence Solution](https://gallery.cortanaintelligence.com/Solution/Interactive-Voice-Response-Bot).
