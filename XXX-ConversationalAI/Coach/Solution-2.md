# Challenge 2: Coach's Guide

[< Previous Challenge](./Solution-1.md) - **[Home](../readme.md)** - [Next Challenge>](./Solution-3.md)

## Notes & Guidance
- The participants will likely run into issues getting synced with LUIS. Make sure they're creating their luis resource as seen here: https://docs.microsoft.com/en-us/azure/cognitive-services/luis/luis-how-to-azure-subscription#create-luis-resources-in-the-azure-portal. This will ensure they have the necessary fields created. 
- Ensure that the participants are not hard coding the bot to respond to only one stock.
- Make sure they understand how to pull out and save the entities for later conversations. They should be saving these an a variable, but this challenge will work without doing so

Here's an example of what their trigger phrases could look like:
![Trigger](./LUIStrigger.png)

- Specifically have them look at https://docs.microsoft.com/en-us/composer/how-to-define-intent-entity#luis-for-entity-extraction. For how to pull out entities
- This challenge should be pretty straight forward, let them struggle somewhat before helping
