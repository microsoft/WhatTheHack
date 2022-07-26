# Challenge 02 -  Introduce Azure Route Server and peer with a Network Virtual appliance

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

In this challenge you will introduce Azure Route Server in the topology you have built previously in order to establish dynamic routing accross the Hub and Spoke Topology. 


## Description

In this challenge you will insert Azure Route Server as described in this diagram:


Please perform the following actions:
- Configure Azure Route Server
- Successfully establish BGP relationship between ARS and the Central Network Virtual Appliance
- Analyze the different routing advertisements (VPN Gateway and ARS)

*For this section, student will also be provided the necessary configuration for a Cisco CSR 1000v to establish BGP relationship with Azure Route Server and remove any stale configuration from the last section. Again, if the student has another third pary NVA preference, please provide the necessary configuration.*

## Success Criteria

At the end of this challenge you should: 
- Verify our environment has no UDRs. 
- Validate the following traffic is still going through the NVA. 
  - spoke-to-spoke
  - spokes-to-onprem
  - onprem-to-hub
  - onprem-to-spokes
- Demonstrate to your coach you understand the behavior of the Route Server for this excercise. 

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
