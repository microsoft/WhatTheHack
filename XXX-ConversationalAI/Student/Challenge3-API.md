# Challenge 3: Making API calls
[< Previous Challenge](./Challenge2-LUIS.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge4-Deployment.md)
## Introduction:

The power of the Bot Service is the ability to add your own API's. In this challenge you will add a HTTP call out to an Open Source data site to get the stock price of certain companies. We'll be building onto the Dialog from the prior challenge and utilizing the entities pulled out from the utterance to make dynamic API calls. As the investment manager it's critical that you get the latest stock data, as prices can change within the hour, minute, or even second. Therefore pulling from a database won't be sufficient for this task.



## Description

1. From your LUIS challenge you're going to extract the entity and call an api. You should already have the syntax necessary for pulling out the entities.
2. Get a [Finnhub](https://finnhub.io/dashboard) API key, we're going to be using it to get the current stock price.
3. We're going to be using the "Quote" feature from Finnhub, look at their [API documentation](https://finnhub.io/docs/api#quote) and get a better understanding of the requirements.
4. In Bot Composer, add a "Send an HTTP request action" inside of your LUIS triggered dialog. 
5. Set the correct properties to the API link. Instead of statically adding the Ticker Name, do it dynamically by pulling out the entity in the utterance sent to the bot.
6. Have the bot print what is sent back from the API. You should not be running into any issues.
7. Develop the  to Ask for a stock and then reply with the opening price of that stock

## Success Criteria
1. The bot successfully calls the Finnhub API without any errors
2. The bot runs in the Bot Framework Emulator and displays the opening stock price.

## Resources:
1. [API Documentation | Finnhub](https://finnhub.io/docs/api)
2. [Send an HTTP request  - Bot Composer](https://docs.microsoft.com/en-us/composer/how-to-send-http-request)

[Next Challenge - Deploying and integrating with Microsoft Teams >](./Challenge4-Deployment.md)
