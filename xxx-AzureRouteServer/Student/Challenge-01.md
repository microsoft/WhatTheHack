# Challenge 01 - Building a Basic Hub and Spoke Topology utilizing a central Network Virtual Appliance

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

In this challenge you will be setting up a basic hub and spoke topology with a Central Network Virtual Appliance. You will also establish connectivity to onprem via VPN site-to-site or Express Route Circuit if you have access to one.

## Description

In this challenge you will create the topology described in this diagram:

![hubnspoke noARS](/xxx-AzureRouteServer/Student/Resources/media/Azure%20Route%20Server%20WTH%20Challenge1.png)

This hack offers configuration templates using Cisco 1000v that you can leverage (below) for each component, the Central Network Virtual Appliance and the On Premises environment simulation "onprem vnet". If you prefer or are experienced with other vendor, please feel free to deploy and provide your own configuration. 

The number of Spokes is up to the student. Two is the suggested number. 

***NOTE:** Please keep in mind, the vendor of your choice will be the one used through the course of this WTH.*

## Success Criteria


At the end of this challenge, you should:

- Have a basic Hub and Spoke Topology in Azure connecting to a simulated On Premises Environment. 
- Verify all traffic is inspected by the Central Network Virtual Appliance:
  - spoke-to-spoke
  - spokes-to-onprem
  - onprem-to-hub
  - on-prem-to-spokes


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
