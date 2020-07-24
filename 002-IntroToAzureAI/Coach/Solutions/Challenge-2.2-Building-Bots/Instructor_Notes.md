# Instructor Notes: Lab 2.2

**This document serves to provide some (hopefully) helpful notes and tips with regards to presenting these materials/labs**

## Building Bots intro [~30 minutes]  

*	Quick poll/discussion to gauge familiarity and use of bots
    *	Ask the room - who has implemented, what are they, what do they think of them, how easy are they to use and access, are they flexible, are there options for customization?
*	Overview of bots using a simple PowerPoint or website screen sharing
    *	UPS C#, Bots, LUIS https://www.youtube.com/watch?v=M8SIs1GfSz0 
    * https://docs.microsoft.com/en-us/bot-framework/bot-service-overview-introduction 
*	Talk about some bot scenarios - use the website as a starting point
    *	https://docs.microsoft.com/en-us/bot-framework/bot-service-scenario-overview
    *	Ask the class if they can think of others or share examples of times they've implemented or even interacted with a bot
    *	Litware insurance bot is a good example (from about 1 min – 9 min, skip probably because too long. Watch ahead of time for ideas.
        *	https://www.youtube.com/watch?v=1xgMEkvEppM
*	Set up the lab 
    *	Goals
    *	Architecture and use case
    *	Demo to them
    *	bots -> regex -> search -> luis
        *	You want to be clear in articulating the purpose/benefits between the steps. Consider demo-ing each stage and why it leads to the next addition
    *	Potentially include a demo of Visual Studio and using the Bot Emulator, depending on class level
        * I've noticed many students don't know that they can pull the log bar up in the emulator
*	Open it up for more discussion depending on time – at the end of the lab
    *	What do you guys think about LUIS? First impressions?
    *	Open it up for more discussion
        *	Questions/Thoughts/Experiences/Challenges


## Lab 2.2 Tips
* Sometimes students fly through this lab, and sometimes it takes a while. Give them the time they need (within reason). This lab really ties together all the services students have been working with
* Remember there are solution files for each steps
* If there are Newtonsoft.Json issues, I recommend removing the package completely and reinstalling it from NuGet
* Many students will try to connect to their bot using the emulator after they've published it, even though it is not in the instructions. To do this, they must enter their AppId and AppPassword and set up ngrok (also checking the two boxes "Bypass ngrok for local addresses" and "Use version 1.0 authentication tokens").




