# Overview

This workshop is designed to give participants familiar with Power BI and Business Intelligence and introduction to Artificial Intelligence and Machine Learning capabilities.  The topics we introduce are designed to help participants identify areas where they can gain additional value out of their investment in business intelligence technologies like Power BI.  Furthermore, this workshop is designed to give participants hands on experience with the technologies.

The format we're following for this is similar to other initiatives like OpenHack and What the Hack.  The material is intended to be light on presentations and heavy on hands on experience.  The participants will spend the majority of their time working on challenges.  The challenges are not designed to be hands on labs, but rather a business problem with success criteria.  The focus here is encouraging the participants to think about what they're doing and not just blindly following steps in a lab.

## Expected / Suggested Timings

The following is expected timing for a standard delivery.

|                                            |                                                                                                                                                       |
| ------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Topic** |  **Duration**  |
| Presentation 1:  Welcome and Introduction  | 30 mins |
| Challenge 1: Environment Setup | 30 mins|
| Presentation 2: Intro to Power BI dataflows | 30 mins|
| Challenge 2: Working with Data in Power BI | 45 mins |
| Presentation 3: Intro to Cognitive Services | 30 mins |
| Challenge 3: Working with Cognitive Services | 45 mins |
| Presentation 4: Machine Learning with Power BI | 30 mins |
| Challenge 4: Building Machine Learning in Power BI | 45 mins |
| Presentation 5: Azure Machine Learning Overview | 30 mins |
| Challenge 5: Building Machine Learning in Azure Machine Learning Auto ML | 60 mins |
| (Optional) Challenge 6: Building Models in Azure Machine Learning Designer | 45 mins |

## Potential variations for delivery

As previously mentioned, this content is geared at trying to strike a balance between something open ended and something totally scripted.  As such this content does assume a basic level of proficiency and familiarity with tools like Power BI, but in the interest of keeping attendees close to the correct path we've included a "Hackflow Steps" section in each challenge.  This is intened not to show the users how to complete the activities, but rather inform them of the general order of tasks required to complete the challenge.   

We realize this may not be ideal for every audience; therefore we see two potential variations of this delivery:

1. For a more advanced audience - you could remove the "Hackflow Steps" section from the challenges.  This would then force the participants to potentially stumble more and read more documentation/tutorials to complete the challenges.  This would push the workshop to more of a "Hackfest" style of activity.
1. For a more novice audience - you could supplement the "Hackflow Steps" with more details and screenshots, to force appropriate implementations.  This would effectively convert the content to more of a "Hands on Lab" style of activity.
1. The final two challenges could be a bit much for some audiences.  These two challenges could potentially be delivered as demos or as instructor led labs.

## Content

In order to deliver this hackshop there is a variety of supporting content.   This content is indexed below.

### Backup

* [AdventureWorksDW](./Backup/AdventureWorksDW.bacpac) - This is a .bacpac file of the AdventureWorksDW with some slight modifications to support this exercise.  While you could recreate this database from scratch using this content in the Sourcefiles location, this is provided to save you time.

### Presentation content

1. [Welcome & Introduction](./Presentations/P01%20-%20Welcome%20&%20Introduction.pptx) - This presentation sets the stage for the event and reviews the topics and agenda.
1. [Intro to Power BI dataflows](./Presentations/P02%20-%20Intro%20to%20Power%20BI%20dataflows.pptx) - AI and ML features in Power BI are activated via dataflows.  This deck introduces dataflows concepts.  (Note: this presentation is intended to be delivered in advance of Challenge 2.)
1. [Intro to Cognitive Services](./Presentations/P03%20-%20Intro%20to%20Cognitive%20Services.pptx) - Power BI makes it simple to leverage some Azure Cognitive services.  This deck introduces Azure Cognitive Services in general and discusses the few cognitive services available in Power BI Dataflows.  (Note: this presentation is intended to be delivered in advance of Challenge 3.)
1. [Machine Learning with Power BI](./Presentations/P04%20-%20Machine%20Learning%20with%20Power%20BI.pptx) - Power BI Auto ML makes it easy to train models with data in your dataflow.  This presentation introduces core machine learning concepts and workflow.  (Note: this presentation is intended to be delivered in advance of Challenge 4.)
1. [Azure Machine Learning Studio](./Presentations/P05%20-%20Azure%20Machine%20Learning%20Studio.pptx) - When you hit the limits of the native capabilities of Power BI, you'll start building Machine Learning and Artificial Intelligence solutions in Azure Machine Learning.  The presentation introduces core concepts and capabilities in Azure Machine Learning (Note: this presentation is intended to be delivered in advance of Challenges 5 - 7.)

### Scripts

These are the supplemental script files that go beyond the standard AdventureWorksDW database.  These are provided here in case you happen to already have a copy of AdventureWorksDW and just want to modify it to work with the challenges.

1. [Create BikeBuyerTraining View.sql](./Scripts/Create%20BikeBuyerTraining%20View.sql) - This creates a view that joins customers with their buying history which is our source for training our classification models.
2. [Create Customers View.sql](./Scripts/Create%20Customers%20View.sql) - This creates a view to simplify the creation of the dataflows.   The customers data in the default model is spread between dimCustomer and dimGeography.  This view flattens those objects into a single dataset.
3. [Create Products View.sql](./Scripts/Create%20Products%20View.sql) - Like the customers view, this view simplifies Products which is spread across dimProduct, dimProductSubCategory, and dimProductCategory, and simplifies this into a single dataset.
4. [CreateAdventureWorksDW.sql](./Scripts/CreateAdventureWorksDW.sql) - this is a slightly modified version of the adventure works creation script modified for running in SQL Azure and restoring from csv files in azure blob storage.

### Database Setup Options 1 & 2

These are  our preferred method as it uses the bacpac that is convenitently stored in azure blob storage already.  These methods are  spelled out in detail in [Challenge 1](/Student/01-Setup.md).

### Database Setup Option 3

If you're a masochist and want to bypass the setup process you can actually build the Adventure Works database from scratch using the data in the "Sourcefiles" directory.  This path includes all the source csv files and scripts to build the database.  The basic steps are as follows.

1.  You must copy all the .csv files to a blob storage container.
1.  You must generate a sas key for the storage container.
1.  You must alter the script to include the appropriate sas key (credential creation)
1.  You must execute the create script in SQL-CMD mode.

The "Scripts" directoty contains additional content that is held separate as they are departures from the "stock" AdventureWorksDW schema.


### Ideas for other Challenges (Punch List)

This area is for us to keep a running list of things we would like to incorporate into the Core or Optional challenges.  Please contact Chris Mitchell (repo owner) if you would like to pick one of these to work on, or want to add a new one yourself.  Help and collaboration are always welcome.

1. An adjunct lab to AML Designer to add in normalization, comparing other algorithms, etc. to hit a higher accuracy
2. An adjunct lab to AML AutoML to add in timeseries forecasting
3. An optional lab to AML Notebooks for time series forecasting
4. Pick an AML tool to dive into Model Transparency and Interpretability 
5. Create a Data Labeling project to label bikes or bike parts, show the team aspect
6. Create a "custom vision" model for bikes and call that from PowerBI
   
