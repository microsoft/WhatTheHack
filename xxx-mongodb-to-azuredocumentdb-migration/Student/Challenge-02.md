# Challenge 02 - Migrating from MongoDB to Azure Document DB

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Prerequisites 

Make sure you have successfully completed Challenges 0 and 1 before starting this challenge. 

## Introduction

In this challenge you will use the Azure DocumentDB Migration extension in Visual Studio Code to migrate the data from source database to Azure DocumentDB. 

## Description
If you were able to successfully connect to your local MongoDB source database in Challenge 1, you should be ready to get started!

- Right click on your source database and select `Data migration`. For the data migration provider, select `Migration to Azure Document DB`
- Put in a Job Name of your choice. For Migration Mode, select `Offline` and for Connectivity, select `Public`
- For the target Azure DocumentDB account
    - Subscription: Use the default subscription
    - Resource Group: Select the resource group where you deployed Azure DocumentDB (default is rg-mflix-documentdb)
    - Account Name: Select the account name
    - Connection String: You will have to retrieve this from the Azure Portal. Open your Azure DocumentDB instance. It should be under Settings/Connection Strings. Replace the password with the password you chose when you ran the `deploy.sh` script. 
- Create the Database Migration Service. You can use the existing resource group for your Azure DocumentDB. 
- You may have to update firewall rules for Azure DocumentDB accordingly. 
- Select all of the collections in your `sample_flix` database.
- Start Migration
## Success Criteria

*Success criteria goes here. The success criteria should be a list of checks so a student knows they have completed the challenge successfully. These should be things that can be demonstrated to a coach.* 

*The success criteria should not be a list of instructions.*

*Success criteria should always start with language like: "Validate XXX..." or "Verify YYY..." or "Show ZZZ..." or "Demonstrate you understand VVV..."*

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

## Tips

*This section is optional and may be omitted.*

*Add tips and hints here to give students food for thought. Sample IoT tips:*

- IoTDevices can fail from a broken heart if they are not together with their thingamajig. Your device will display a broken heart emoji on its screen if this happens.
- An IoTDevice can have one or more thingamajigs attached which allow them to connect to multiple networks.

## Advanced Challenges (Optional)

*If you want, you may provide additional goals to this challenge for folks who are eager.*

*This section is optional and may be omitted.*

*Sample IoT advanced challenges:*

Too comfortable?  Eager to do more?  Try these additional challenges!

- Observe what happens if your IoTDevice is separated from its thingamajig.
- Configure your IoTDevice to connect to BOTH the mothership and IoTQueenBee at the same time.
