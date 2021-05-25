# Challenge 6: Integrate your Bot with Azure Communication Services
[< Previous Challenge](./Challenge5-FrontEnd.md) - **[Home](../README.md)** - [Next Challenge>](./Challenge7-CICD.md)

## Introduction
Now that we've finished deployed our Bot into Azure. You can extend your Bot from a Bot2Human interaction to Human2Human interaction through Azure Communication Services. Azure Communication Services allows you to easily add real-time multimedia voice, video, and telephony-over-IP communications features to your applications. The use case for our FSI Bot and the goal of this challenge is for you to create a functionality that allows use initiate a 'talk to human' intent, which allows the user of your bot to talk to a finance expert through video chat.
	
## Description
1.	Create a Web Call Service using Azure Communication Services (portal or IaC)

    Hint: There is a web call sample that could be leveraged for this challenge and it can be found here: https://docs.microsoft.com/en-us/azure/communication-services/samples/calling-hero-sample

2. In your Bot Composer, create an Intent and a Dialog which triggers the API call to your Web Call Service.
 
## Success Criteria
* There is a 'Call Agent' intent from your bot. User can initiate a video chat through the Bot 'Call Agent' dialog.
* What a sample result looks like:
![Sample](./Images/Ch6-1.JPG)
![Sample](./Images/Ch6-2.JPG)

## Resources
*	[Azure Communication Server - What is Azure Communication Services?](https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Fcommunication-services%2Foverview&data=04%7C01%7CAnnie.Xu.Dan%40microsoft.com%7C3c9f2316780d4f03254308d8be72ba71%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C637468747245008647%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&sdata=LwmhcveRp6vIaopbUKZauFMYlpIc8kyc%2B5QdvwjiuVM%3D&reserved=0)

*	[Group Calling Sample](https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Fcommunication-services%2Fsamples%2Fcalling-hero-sample&data=04%7C01%7CAnnie.Xu.Dan%40microsoft.com%7C3c9f2316780d4f03254308d8be72ba71%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C637468747245008647%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&sdata=m0tXKASvI05Rt%2BT%2B9zNzbbkzSXElGMmtzruPKRkymxY%3D&reserved=0)

*	[Azure Communication Server GitHub Repo](https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FAzure%2Fcommunication&data=04%7C01%7CAnnie.Xu.Dan%40microsoft.com%7C3c9f2316780d4f03254308d8be72ba71%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C637468747245018605%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&sdata=%2FBY5fUXTTY%2B0WxpVCvcMysWvmhCFXchG8rWVs8F3CMA%3D&reserved=0)





[Next Challenge -  Implement DevOps best practices into your Bot >](./Challenge7-CICD.md)
