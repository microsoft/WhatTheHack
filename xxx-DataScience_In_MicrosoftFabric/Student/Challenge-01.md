# Challenge 01 - <Title of Challenge>

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

***This is a template for a single challenge. The italicized text provides hints & examples of what should or should NOT go in each section.  You should remove all italicized & sample text and replace with your content.***

## Introduction

As you observed at the end of setup in Challenge 0, you have been provided with some anonimized historical data of patients who have suffered heart attacks. The csv file contains a set of conditions (or features) that these patients have had and an indication of whether they had a heart attack or not. The first step to working with this data is to bring it to Fabric's OneLake, from where you will be able to use it for your analysis and to train a machine learning model.

## Description

Your task in this challenge is to make your data available as a delta table in the Fabric OneLake. To do so, you must:
-Create a shortcut to the heart.csv file located in ADLS Gen2. 
-Load the data to the lakehouse you will be using throughout this hack

To load the data to the lakehouse, you will be using a spark notebook. Open notebook 1 that you uploaded to your Fabric workspace in Challenge 0. You will find more guidance and helpful links there. Additionally, visit the end of this challenge for documentation links on how to create a shortcut in Fabric.

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
