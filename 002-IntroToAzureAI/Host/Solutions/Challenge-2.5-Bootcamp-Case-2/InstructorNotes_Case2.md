  **Q&A Part 2 (Potential Answers)**
==================================
 

### Case

You are working with Contoso LLC, which sells bicycles and bicycle equipment to
its customers. Contoso currently processes new product orders and queries
through human operators, and are starting to devise a plan to implement your
proposed solution using bots. The solution will provide an automated approach
that allows Contoso to seamlessly scale up to handle a large call volumes while
maintaining zero wait times and freeing up staff to manage other tasks. 

### Assignment

You have been tasked to highlight the value that can be added to the business by
using enhanced features of the bot framework.

**Which features from Azure Search should you take advantage of?**
* Geospatial - maybe they want to know which store is closest to them, or they only want to know about items in stock at a specific store
* Boosting - you may want to return higher-profit bikes or items in your list when they search, or maybe you want use ranking and go from frequently purchased to not
* Facets - maybe they want results in different areas, e.g. bikes, clothing, gloves, etc.
* Regularly scheduled indexer for Azure SQL the options change depending on what's in stock
* Monitoring, reporting and analyses to determine what is asked about, maybe things asked about more, you keep more and similar products in stock.  

**How can bot logging be used to benefit Contoso**?

  **Potential Answers. (Other answers are also valid)**

* Logging can be provided at two levels. Activity logging and File logging.

* Activity logging is used to log message activities between bots and users using the IActivityLogger interface. Collecting this information can provide a real time snapshot into the how busy the bot is working.

* File logging uses the same information collected by activity logging but persists the data within a file. Therefore, retaining the data that could be used for further analysis such as:  
  * Identifying how many customers within your overall population make use of the customer service function.

  * Understanding the frequency with which a user is making use of the customer support, and therefore understand the potential cost of support, and understanding anomalies such as customers who have a very high frequency of using customer service.

  * Understand the context of the bot interactions by capturing the message content

  * Damage control, with real time sentiment analysis of the bot-user iteration, so the chat can be routed to a real person to solve a problem.

* There maybe the potential to take this data and mine it to identify patterns where there are peaks in Customer service usage, and perhaps predict future patterns of users using the service. This could help Contoso resource the department appropriately and optimize the cost of running the support function

* Logging is not just limited to files, you could log to Azure SQL DB, but you should be sensitive to the potential performance impact  


**What are some tasks you'll have to complete to create an efficient and functional calling bot?**
* Call the Bing Speech API to get text-to-speech and speech-to-text
* Incorporate LUIS and call the intents
* Incorporate Search and call the service to search Azure SQL
* Implement a Regex structure to minimize hits to LUIS
* Might also be able to take advantage of FormFlow
* Might set up the Skype channel to handle calls

Work in team of 4 or 5 as assigned by the instructor to discuss the options that
are available. This will be time limited between 20 - 30 mins.

 

### Discussion

Your instructor will invite a member of your team to provide a description of
your answer and discuss with the wider group

 
-
