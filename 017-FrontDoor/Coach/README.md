# Front Door WhatTheHack!

## Introduction

The style of this hack has almost all of the information embedded in the Challenges.  There maybe a PowerPoint included in the future to kick off.  Please review the [How to Host a Hack](../../000-HowToHack/WTH-HowToHostAHack.md) document.

The recommended flow for this WhatTheHack:
- We want to ground folks in a basis that the is a pretty complicated, very public resource.  Public means you have very little control.
  - Show the video [How does the Internet work? (video)](https://youtu.be/yJJHukw9Lyc)
    - [Other Languages available - "The Euro-IX Video"](https://www.youtube.com/channel/UCFyucVRAAMzxyJIsxnGwsjw)
  - Show the video [How the Internet crosses the Ocean (English Only)](https://www.weforum.org/agenda/2016/01/how-does-the-internet-cross-the-ocean/)

## Coach's Guides
  - Challenge 1: [Setup your Environment and Discover](Solution01.md)
    - Get your local and Azure Environment ready 
  - Challenge 2: [Provision your Front Door](Solution02.md)
    - Get the basic Front Door setup
  - Challenge 3: [Provision a Web Application Firewall (WAF)](Solution03.md)
    - Protect the Web Site
  - Challenge 4: [Offload traffic for a high traffic event](Solution04.md)
    - Redirect traffic for a part of the website to a Static Web Site
  - Challenge 5: [Force HTTPS thru Rules Engine](Solution05.md)
    - Write your frist rule!

## Additional Resource
Under the [Resources](./Resources) folder, there are two folders the contain single item resources that are hosted centrally.  **THERE IS NO ACTION FOR COACHES**:
- [ContosoMasks.com](Resources/ContosoMasks.com) - Source code for the Demo site.  It's deployed in a central Azure subscription and can be accessed:
  - https://www.contosomasks.com - Base website direct to App Service
  - https://frontdoor.contosomasks.com - Front Door fronted version
  - https://frontdoorwithredirect.contosomasks.com - Front Door fronted version with redirection rule to a Static Website for /Messages
  - https://frontdoorwithwaf.contosomasks.com - Front Door fronted version with WAF
- [frontdoor-cdn-lab-management](./Resources/frontdoor-cdn-lab-management) - Source code for Function app that manages the lab.  It's centrally hosted, **no need for coach deployment**.  The central deployment has the Public DNS Zone for **ContosoMasks.com**.  When a student does the first Challenge and deploys the template, the deployment calls one of hte functions to create the necessary records in the DNZ Zone for **ContosoMasks.com** to properly delegate the subdomain the student will use for the lab.  Another function runs on a timer and ensures to clean up old records.
