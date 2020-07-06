### Notes for Challenge 0 - Cache Static Assets

 [< Previous Challenge [3]](./Solution03.md) - **[Home](./README.md)**


This article [https://docs.microsoft.com/en-us/azure/frontdoor/front-door-tutorial-rules-engine](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-tutorial-rules-engine) actually describes the process really well.  Basically the end result should have 5 rules, one for each of the base URLs:
- **/css**
- **/images**
- **/js**
- **/lib**
- **/message**

They all look identical (UI Only), change only the name on the top (CacheMessage) and Value to the base URLs:
![alt](RuleExample.png)

The rules are case-sensitive, its recommended to make sure all "Values" are lowercase and the "To Lowercase" Transform is selected.  

After the Rules engine is created it needs to be applied to each Backend.