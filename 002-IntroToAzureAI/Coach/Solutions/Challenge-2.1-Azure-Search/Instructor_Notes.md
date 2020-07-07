# Instructor Notes: Lab 2.1

**This document serves to provide some (hopefully) helpful notes and tips with regards to presenting these materials/labs**

## Azure Search intro [20-25 minutes]  

* I recommend starting with a quick review of the previous day and project architecture, and then going through the agenda for day 2.

*	Intro to Azure Search – open for discussion
    *	How many of you have used AZS before?
    *	What is it?
    *	Why would someone want it?
    *	Azure Search is a search-as-a-service solution that allows developers to create great search experiences within their apps. The cool thing is, you don’t have to become a search expert or manage the infrastructure. Today we’ll learn how to create a search service and index to give users what they want.
*	The high expectations of a search service
    *	Use the example in the demo, alternatively pull up a common retail site for the location and show the search features
    *	With web search engines like Google and Bing and retailers like Amazon, the bar is set high for the search experience. So if we look at this example, we can see some of the things people look for in a good search experience, which I am sure you are familiar with. You want to be able to spell things wrong and get answers, you want type ahead suggestions, you want to be able to sort and filter, you want your search words highlighted in the results, etc. You all know what I am talking about right?
*	What AZS does
    *	Gives your consumers the experience they expect, without you having to be or hire a search expert
    *	Azure Search gives your consumers that, but what does it give you? Well, you get monitoring and reporting, you can get scoring and boost items you want to show up higher in the list (maybe products with a higher product margin?) and more. 
*	Workflow
    *	Provision service – same as most resources, you can create it in the portal
    *	Create an index which is a container for your data
    *	Index data – you’ll import your data (https://docs.microsoft.com/en-us/azure/search/search-what-is-data-import ) then you’ll create an indexer, which basically specifies how to search your data
    *	Then you search!
*	Step through the lab, explaining the main steps
    *	When you get to picking the Microsoft vs Lucene Analyzer, demo this site to compare: alice.unearth.ai/ 
*	AZS discussion – lab wrap up at the end 
    *	What do you guys think about LUIS? First impressions?
    *	Open it up for more discussion
        *	Questions/Thoughts/Experiences/Challenges


## Lab 2.1 Tips
* We've noticed that this is often the product students have the least experience with. If this is the case, expect them to ask more questions and spend more time discussing. If you have to give on some of the time for Q&A, that's ok.
* If you get questions about performance, refer here: https://docs.microsoft.com/en-us/azure/search/search-capacity-planning
* If you get questions about scoring profiles, refer here: https://docs.microsoft.com/en-us/rest/api/searchservice/add-scoring-profiles-to-a-search-index




