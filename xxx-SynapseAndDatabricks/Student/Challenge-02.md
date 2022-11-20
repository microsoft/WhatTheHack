# Challenge 02 - Striving for Silver

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

*This page is currently being worked on*

## Introduction

In this challenge we will begin to transform the data we loaded "as is" into the Bronze layer into more "standardized" and "integrated" datasets that are then loaded into the Silver layer.

## Description

Some of the things we try to achieve within the Silver layer are
- __Domain Separation__  
  An important point to keep in mind is that in the Bronze layer, the data is often organized based on the Source System or source object name, on the contrary, in the Silver layer the data is organized by Domain, such as Customer or Product. 
- __Consolidation__  
  We also try and consolidate the disparate data structures on the source side into a more conformed structure. For example, we could have 10 different sources bringing in various kinds of Customer data but in the Silver layer we try and keep one consistent structure for our Customer data and mold our source data accordingly.
- __Data Type Standardization__  
  As part of the new consolidation, we try and standardize the data types in our Silver layer structures and mold our source data accordingly.
- __Formatting__  
  Continuing with the trend of standardizing, we make sure our Silver layer data does not have different kinds of formatting within the data. We could do that by doing things such as enforcing NULLs if needed, cleaning up blank spaces, syncing up decimal points across the sources etc.
- __Partitioning and Sharding__  
  Although optional for this challenge, this is highly recommended for more production focused use cases. Making sure the data is appropriately physically arranged insures efficient access when doing ad-hoc analysis or when pulling to the Gold Layer.

## Success Criteria

*Sample success criteria for the IoT sample challenge:*

To complete this challenge successfully, you should be able to:
- Verify that the IoT device boots properly after its thingamajig is configured.
- Verify that the thingamajig can connect to the mothership.
- Demonstrate that the thingamajic will not connect to the IoTProxyShip

## Learning Resources

_List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge._

*Think of this list as giving the students a head start on some easy Internet searches. However, try not to include documentation links that are the literal step-by-step answer of the challenge's scenario.*

***Note:** Use descriptive text for each link instead of just URLs.*

*Sample IoT resource links:*

- [What is a Thingamajig?](https://www.bing.com/search?q=what+is+a+thingamajig)
- [10 Tips for Never Forgetting Your Thingamajic](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
- [IoT & Thingamajigs: Together Forever](https://www.youtube.com/watch?v=yPYZpwSpKmA)





