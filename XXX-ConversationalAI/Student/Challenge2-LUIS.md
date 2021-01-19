# Challenge 2 - Implementing LUIS
[< Previous Challenge](./Challenge1-QnA.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge3-API.md)
## Introduction
LUIS is a cloud-based conversational AI service that applies custom machine-learning intelligence to a user's conversational, natural language text to predict overall meaning, and pull out relevant, detailed information. LUIS easily integrated in the Bot Composer so that you can trigger a different dialog flow according to the intent of the User's utterance. 

We are going to build out a LUIS triggered dialog flow to help answer the current stock price, we'll implement returning the actual price in the next challenge. For now we are just going to recognize that the utterance is Stock based and return out the Ticker Symbol that is included in the utterance. Below goes into more depth

- This intent is aimed to recognize when a Stock question is being ask. So it should recognize both
  - What is the MSFT stock today?
	- Get me the stock price of TSLA
	- Provide me with more information on the stock opening price for AAPL. 
- We also want to pull out the entity information for the Ticker Symbol in each utterance. In the above examples the entities we would pull out would be: MSFT, TSLA, and AAPL respectively.


## Description
1. Add a new trigger by Intent, name the intent something that makes sense like StockPrice
2. Then  add the trigger phrases, this will actually train the LUIS model. The best practice is that your utterances are  unique, with significantly different phrasing.
3. In the same box that you add trigger phrases you can also train the model to detect Stock Symbols like MSFT, APPL, TSLA, JKS using entity extraction.
4. Add dialog in this trigger to print back out the stock that they are asking for. The flow of the Bot should look like this to the user
   - Bot: "Hello I am the FSIBot. Please ask me a question about ESG ratings or Stocks."
   - User: " What is the stock price of 
5. Test your bot locally with unknown phrases and entities

## Success Criteria
1. The bot runs without errors in the Bot Framework Emulator
2. The bot can recognize when the utterance has a StockPrice intent and triggers the correct conversational flow

## Resources
1. [Introduction to LUIS](https://docs.microsoft.com/en-us/composer/tutorial/tutorial-luis)
2. [Define intents with entities](https://docs.microsoft.com/en-us/composer/how-to-define-intent-entity)

[Next Challenge - Making API Calls >](./Challenge3-API.md)
