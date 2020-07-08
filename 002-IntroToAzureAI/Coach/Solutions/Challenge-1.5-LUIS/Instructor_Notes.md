# Instructor Notes: Lab 1.5

**This document serves to provide some (hopefully) helpful notes and tips with regards to presenting these materials/labs**

## LUIS intro [20-25 minutes]  

* Intro to LUIS
    *	What is NLP?
        *	Natural language processing (NLP) is a field of computer science, artificial intelligence concerned with the interactions between computers and human (natural) languages, and, in particular, concerned with programming computers to fruitfully process large natural language data.
        *	Challenges in natural language processing frequently involve speech recognition, natural language understanding, and natural language generation.
        *	https://en.wikipedia.org/wiki/Natural_language_processing 
    *	Why is NLP important to us? What can it help us with? Open it up for discussion about use cases
    *	About LUIS: https://docs.microsoft.com/en-us/azure/cognitive-services/LUIS/home
    *	Plan your app: https://docs.microsoft.com/en-us/azure/cognitive-services/LUIS/plan-your-app
    *	Walk through all of the Build a Luis app sections, skipping Improve performance using features, and getting too much into entities
    *	Briefly talk about prebuilt entities and prebuilt domains
*	Briefly scroll through the lab as a preview, don't spend too much time, let them explore on their own
*	LUIS discussion – lab wrap up at the end 
    *	What do you guys think about LUIS? First impressions?
    *	Open it up for more discussion
        *	Questions
        *	Thoughts
        *	Experiences
        *	Challenges

## Lab 1.5 Tips
* Sometimes students miss that the facets should be the search query (I've seen many one-word entities and entities labeling the word "search"). May be good to stress this, else expect errors similar to those described.
* Students sometimes have questions about the keys for different locations. You can access the same model with different keys for different locations
* For later labs: You have to train and publish the app before it will work in the bot
* Stress that if they don't name their intents exactly as stated in the instructions, they may have issues later when they compile the bot (the biggest mistake I've seen is "Greeting" vs "Greetings")


